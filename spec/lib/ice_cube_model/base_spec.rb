require 'spec_helper'

describe ::IceCubeModel do
  class HashAttrs
    def initialize(attributes = {})
      @attributes = {
        :repeat_start_date => nil,
        :repeat_interval => nil,
        :repeat_year => nil,
        :repeat_month => nil,
        :repeat_day => nil,
        :repeat_weekday => nil,
        :repeat_week => nil
      }.merge(attributes)
    end

    def method_missing(m, *args, &_block)
      if m =~ /[a-z_]+=/
        attribute = m.to_s.strip.chop.to_sym
        return @attributes[attribute] = args[0] if @attributes.key?(attribute)
      else
        return @attributes[m] if @attributes.key?(m)
      end

      fail ArgumentError, "Method `#{m}` doesn't exist."
    end
  end

  class IceCubeObj < HashAttrs
    include ::IceCubeModel::Base
  end

  let(:ice_cube_model) do
    ::IceCubeObj.new(
      :repeat_start_date => ::Date.new(2015, 6, 1)
    )
  end

  context 'repeat options' do
    describe 'monthly' do
      before { ice_cube_model.repeat_day = '1' }

      it 'for same day' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 1))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 8, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'twice monthly' do
      before { ice_cube_model.repeat_day = '1,15' }

      it 'for one month' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15)])
      end

      it 'for two months' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 8, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15), ::Date.new(2015, 8, 1), ::Date.new(2015, 8, 15)])
      end
    end

    describe 'bi-monthly' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 5, 1),
          :repeat_day => '1',
          :repeat_interval => '2'
        )
      end

      it 'for one month' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 10, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'every week' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 7, 6),
          :repeat_weekday => '1',
          :repeat_day => nil
        )
      end

      it 'for one week' do
        expect(
          ice_cube_model.events_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for one month' do
        expect(
          ice_cube_model.events_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 8, 31)
          )
        ).to eq(
          [
            ::Date.new(2015, 7, 6),
            ::Date.new(2015, 7, 13),
            ::Date.new(2015, 7, 20),
            ::Date.new(2015, 7, 27),
            ::Date.new(2015, 8, 3),
            ::Date.new(2015, 8, 10),
            ::Date.new(2015, 8, 17),
            ::Date.new(2015, 8, 24),
            ::Date.new(2015, 8, 31)
          ]
        )
      end
    end

    describe 'bi-weekly' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 7, 6),
          :repeat_weekday => '1',
          :repeat_day => nil,
          :repeat_interval => '2'
        )
      end

      it 'for one week' do
        expect(
          ice_cube_model.events_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for two months' do
        expect(
          ice_cube_model.events_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 8, 31)
          )
        ).to eq(
          [
            ::Date.new(2015, 7, 6),
            # ::Date.new(2015, 7, 13),
            ::Date.new(2015, 7, 20),
            # ::Date.new(2015, 7, 27),
            ::Date.new(2015, 8, 3),
            # ::Date.new(2015, 8, 10),
            ::Date.new(2015, 8, 17),
            # ::Date.new(2015, 8, 24),
            ::Date.new(2015, 8, 31)
          ]
        )
      end
    end

    describe 'annually' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 1, 1),
          :repeat_month => 2,
          :repeat_day => 1
        )
      end

      it 'for one year' do
        expect(ice_cube_model.events_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end

      it 'for two years' do
        expect(ice_cube_model.events_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1), ::Date.new(2016, 2, 1)])
      end
    end

    describe 'bi-annually' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 1, 1),
          :repeat_interval => 2,
          :repeat_month => 2,
          :repeat_day => 1
        )
      end

      it 'for two years' do
        expect(ice_cube_model.events_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end
    end

    describe 'last weekday of month' do
      context '31 day month' do
        let(:ice_cube_model) do
          ::IceCubeObj.new(
            :repeat_start_date => ::Date.new(2015, 1, 1),
            :repeat_weekday => '5L'
          )
        end

        it 'for one month' do
          expect(ice_cube_model.events_between(::Date.new(2015, 12, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 12, 25)])
        end
      end

      context '29 day month' do
        let(:ice_cube_model) do
          ::IceCubeObj.new(
            :repeat_start_date => ::Date.new(2015, 1, 1),
            :repeat_weekday => '3L'
          )
        end

        it 'for one month' do
          expect(ice_cube_model.events_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 24)])
        end
      end
    end

    describe 'Nth day of week of month' do
      let(:ice_cube_model) do
        ::IceCubeObj.new(
          :repeat_start_date => ::Date.new(2015, 1, 1),
          :repeat_weekday => '1#2'
        )
      end

      it 'for one month' do
        expect(ice_cube_model.events_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 8)])
      end

      it 'for mutiple months' do
        expect(ice_cube_model.events_between(::Date.new(2016, 2, 1), ::Date.new(2016, 4, 30))).to eq([::Date.new(2016, 2, 8), ::Date.new(2016, 3, 14), ::Date.new(2016, 4, 11)])
      end
    end
  end

  context 'input types' do
    let(:ice_cube_model) do
      ::IceCubeObj.new(
        :repeat_start_date => ::DateTime.new(2015, 5, 1),
        :repeat_day => '1',
        :repeat_interval => '2'
      )
    end

    it 'handles ::DateTime as input' do
      expect(ice_cube_model.events_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end

    it 'handles integer (epoch) as input' do
      ice_cube_model.repeat_start_date = 1_430_438_400 # Fri, 01 May 2015 00:00:00 GMT
      expect(ice_cube_model.events_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end
  end

  context '::IceCubeModel::Base' do
    describe '#events_between' do
      it 'should emit [::Time]' do
        results = ice_cube_model.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))
        expect(results).to eq([::Date.new(2015, 7, 1)])
        expect(results[0]).to be_a(::Time)
      end
    end
  end

  context '::ClassMethods' do
    describe '#with_repeat_param' do
      class IceCubeObjWithParameterMappings < HashAttrs
        include ::IceCubeModel::Base

        with_repeat_param(:repeat_start_date, :start_date) # remap attribute to another
        with_repeat_param(:repeat_interval, :interval)     # remap attribute to a method
        with_repeat_param(:repeat_day, -> { 1 })           # map parameter to lambda

        def initialize(options = {})
          super(
            {
              :start_date => nil
            }.merge(options)
          )
        end

        def interval
          1
        end
      end

      let(:ice_cube_model) do
        ::IceCubeObjWithParameterMappings.new(
          :start_date => ::Date.new(2015, 1, 1),
          :repeat_month => 2
        )
      end

      it 'should use class mappings' do
        expect(ice_cube_model.events_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end

      class IceCubeObjWithParameterMappingsChild < IceCubeObjWithParameterMappings
        # Adding these currently mess up parent class mappings
        # with_repeat_param(:repeat_start_date, :starting) # remap attribute to another
        # with_repeat_param(:repeat_interval, :interval)   # remap attribute to a method

        def initialize(options = {})
          super(
            {
              :starting => nil
            }.merge(options)
          )
        end

        def interval
          2
        end
      end

      it 'should support inheritance' do
        ice_cube_model = ::IceCubeObjWithParameterMappingsChild.new(
          :starting => ::Date.new(2015, 1, 1),
          :repeat_day => 2
        )

        skip 'Not supported yet'
        expect(ice_cube_model.events_between(::Date.new(2015, 1, 1), ::Date.new(2015, 4, 30))).to eq([::Date.new(2015, 1, 2), ::Date.new(2015, 3, 2)])
      end
    end
  end
end

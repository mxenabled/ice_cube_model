require 'spec_helper'

describe ::IceCubeModel do
  class IceCubeObj < HashAttrs
    include ::IceCubeModel::Base
  end

  let(:ice_cube_model) do
    ::IceCubeObj.new(
      :repeat_start_date => ::Date.new(2015, 6, 1)
    )
  end

  describe '.schedule' do
    it 'assigns all information' do
      ice_cube_model.repeat_interval = 1
      ice_cube_model.repeat_year = 2015
      ice_cube_model.repeat_month = 2
      ice_cube_model.repeat_day_of_month = 3
      ice_cube_model.repeat_day_of_week = 4
      ice_cube_model.repeat_hour = 5
      ice_cube_model.repeat_minute = 6

      validations = ice_cube_model.schedule.recurrence_rules.first.validations

      expect(validations[:interval].first.interval).to eq(1)
      expect(validations[:year].first.value).to eq(2015)
      expect(validations[:month_of_year].first.value).to eq(2)
      expect(validations[:day_of_month].first.value).to eq(3)
      expect(validations[:day].first.value).to eq(4)
      expect(validations[:hour_of_day].first.value).to eq(5)
      expect(validations[:minute_of_hour].first.value).to eq(6)
    end
  end

  context '::ClassMethods' do
    describe '#with_repeat_param' do
      class IceCubeObjWithParameterMappings < HashAttrs
        include ::IceCubeModel::Base
        include ::IceCubeModel::Delegator

        with_repeat_param(:repeat_start_date, :start_date) # remap attribute to another
        with_repeat_param(:repeat_interval, :interval)     # remap attribute to a method
        with_repeat_param(:repeat_day_of_month, -> { 5 }) # map parameter to lambda

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
        expect(ice_cube_model.schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 5)])
      end

      context 'with inheritance' do
        class IceCubeObjWithParameterMappingsChild < IceCubeObjWithParameterMappings
          with_repeat_param(:repeat_start_date, :starting) # remap attribute to another
          with_repeat_param(:repeat_interval, :interval)   # remap attribute to a method
          # with_repeat_param(:repeat_day_of_month, -> { 5 })       # comes from parent ::IceCubeObjWithParameterMappings

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

        let(:ice_cube_model) do
          ::IceCubeObjWithParameterMappingsChild.new(
            :starting => ::Date.new(2015, 1, 1)
          )
        end

        it 'should inherit mappings and remap new mappings' do
          expect(ice_cube_model.schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 4, 30))).to eq([::Date.new(2015, 1, 5), ::Date.new(2015, 3, 5)])
        end
      end

      context 'with missing parameters' do
        class IceCubeObjWithMissingParameters
          include ::IceCubeModel::Base
          include ::IceCubeModel::Delegator

          attr_accessor :repeat_start_date
          attr_accessor :repeat_day_of_month

          with_repeat_param :repeat_hour, -> { 0 }
          with_repeat_param :repeat_minute, -> { 0 }
        end

        it 'should work when class missing parameters' do
          ice_cube_model = ::IceCubeObjWithMissingParameters.new

          ice_cube_model.repeat_start_date = ::Date.new(2015, 1, 1)
          ice_cube_model.repeat_day_of_month = 2

          expect(ice_cube_model.schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 2, 28))).to eq([::Date.new(2015, 1, 2), ::Date.new(2015, 2, 2)])
        end

        it '#respond_to?' do
          ice_cube_model = ::IceCubeObjWithMissingParameters.new
          expect(ice_cube_model.respond_to?(:repeat_day_of_month)).to be(true)
          expect(ice_cube_model.respond_to?(:repeat_interval)).to be(false)
          expect(ice_cube_model.respond_to?(:methods)).to be(true)
        end
      end
    end
  end
end

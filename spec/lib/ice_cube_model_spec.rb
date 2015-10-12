require 'spec_helper'

describe ::IceCubeModel do
  class CyclicalObj
    include ::IceCubeModel::Base

    def initialize(options = {})
      @options = {
        :start_date => nil,
        :repeat_interval => nil,
        :repeat_year => nil,
        :repeat_month => nil,
        :repeat_day => nil,
        :repeat_weekday => nil,
        :repeat_week => nil
      }.merge(options)
    end

    def method_missing(m, *_args, &_block)
      return @options[m] if @options.key?(m)
      fail ArgumentError, "Method `#{m}` doesn't exist."
    end
  end

  describe 'monthly' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 6, 1),
        :repeat_day => '1'
      )
    end

    it 'should emit [::Date]' do
      results = projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))
      expect(results).to eq([::Date.new(2015, 7, 1)])
      expect(results[0]).to be_a(::Date)
    end

    it 'should render same day' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 1))).to eq([::Date.new(2015, 7, 1)])
    end

    it 'should render across multiple months' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 8, 1), ::Date.new(2015, 9, 1)])
    end
  end

  describe 'twice monthly' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 6, 1),
        :repeat_day => '1,15'
      )
    end

    it 'should render one month' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15)])
    end

    it 'should render one month' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 8, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15), ::Date.new(2015, 8, 1), ::Date.new(2015, 8, 15)])
    end
  end

  describe 'bi-monthly' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 5, 1),
        :repeat_day => '1',
        :repeat_interval => '2'
      )
    end

    it 'should render one month' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
    end

    it 'should render multiple months' do
      expect(projector.events_between(::Date.new(2015, 7, 1), ::Date.new(2015, 10, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1)])
    end
  end

  describe 'every week' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 7, 6),
        :repeat_weekday => '1',
        :repeat_day => nil
      )
    end

    it 'should render one week' do
      expect(
        projector.events_between(
          ::Date.new(2015, 7, 1),
          ::Date.new(2015, 7, 7)
        )
      ).to eq([::Date.new(2015, 7, 6)])
    end

    it 'should render one month' do
      expect(
        projector.events_between(
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

  describe 'every two weeks' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 7, 6),
        :repeat_weekday => '1',
        :repeat_day => nil,
        :repeat_interval => '2'
      )
    end

    it 'should render one week' do
      expect(
        projector.events_between(
          ::Date.new(2015, 7, 1),
          ::Date.new(2015, 7, 7)
        )
      ).to eq([::Date.new(2015, 7, 6)])
    end

    it 'should render one month' do
      expect(
        projector.events_between(
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
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 1, 1),
        :repeat_month => 2,
        :repeat_day => 1
      )
    end

    it 'should render one year' do
      expect(projector.events_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 1)])
    end
  end

  describe 'bi-annually' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::Date.new(2015, 1, 1),
        :repeat_interval => 2,
        :repeat_month => 2,
        :repeat_day => 1
      )
    end

    it 'should render two year' do
      expect(projector.events_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1)])
    end
  end

  describe 'last weekday of month' do
    context '31 day month' do
      let(:projector) do
        ::CyclicalObj.new(
          :start_date => ::Date.new(2015, 1, 1),
          :repeat_day => '31, 30, 29, 28, 27, 26, 25',
          :repeat_weekday => 5
        )
      end

      it 'should render' do
        expect(projector.events_between(::Date.new(2015, 12, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 12, 25)])
      end
    end

    context '31 day month' do
      let(:projector) do
        ::CyclicalObj.new(
          :start_date => ::Date.new(2015, 1, 1),
          :repeat_day => '31, 30, 29, 28, 27, 26, 25',
          :repeat_weekday => 1
        )
      end

      it 'should render' do
        expect(projector.events_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 29)])
      end
    end
  end

  describe 'handles ::DateTime as input' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => ::DateTime.new(2015, 5, 1),
        :repeat_day => '1',
        :repeat_interval => '2'
      )
    end

    it 'should render one month' do
      expect(projector.events_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end
  end

  describe 'handles integer (epoch) as input' do
    let(:projector) do
      ::CyclicalObj.new(
        :start_date => 1_430_438_400, # Fri, 01 May 2015 00:00:00 GMT
        :repeat_day => '1',
        :repeat_interval => '2'
      )
    end

    it 'should render one month' do
      expect(projector.events_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end
  end
end

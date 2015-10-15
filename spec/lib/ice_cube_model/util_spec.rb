require 'spec_helper'

describe ::IceCubeModel::Util do
  describe '#sanitize_date_param' do
    it 'should handle epoch time' do
      expect(described_class.sanitize_date_param(1_430_438_400)).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end

    it 'should handle date' do
      expect(described_class.sanitize_date_param(Date.new(2015, 5, 1))).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end

    it 'should handle datetime' do
      expect(described_class.sanitize_date_param(DateTime.new(2015, 5, 1, 0, 0, 0))).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end
  end

  describe '#sanitize_week_day_param' do
    it 'should accept non-nth weekday expression' do
      expect(described_class.sanitize_week_day_param('1')).to eq([1])
    end

    it 'should accept nth weekday expression' do
      expect(described_class.sanitize_week_day_param('1#3')).to eq([{ 1 => [3] }])
    end

    it 'should accept last weekday expression' do
      expect(described_class.sanitize_week_day_param('1L')).to eq([{ 1 => [-1] }])
    end
  end

  describe '#nth_day?' do
    it 'should accept nil' do
      expect(described_class.nth_day?(nil)).to be false
    end

    it 'should accept non-nth weekday expression' do
      expect(described_class.nth_day?([1])).to be false
    end

    it 'should accept nth weekday expression' do
      expect(described_class.nth_day?([{ 1 => [3] }])).to be true
    end
  end
end

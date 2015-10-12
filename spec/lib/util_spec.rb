require 'spec_helper'

describe ::IceCubeModel::Util do
  describe '#sanitize_date_param' do
    it 'should handle epoch time' do
      expect(::IceCubeModel::Util.sanitize_date_param(1_430_438_400)).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end

    it 'should handle date' do
      expect(::IceCubeModel::Util.sanitize_date_param(Date.new(2015, 5, 1))).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end

    it 'should handle datetime' do
      expect(::IceCubeModel::Util.sanitize_date_param(DateTime.new(2015, 5, 1, 0, 0, 0))).to eq(DateTime.new(2015, 5, 1, 0, 0, 0))
    end
  end
end

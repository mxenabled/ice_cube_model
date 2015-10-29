require 'spec_helper'

describe ::IceCubeModel::Delegator do
  class IceCubeObjWithDelegates < HashAttrs
    include ::IceCubeModel::Base
    include ::IceCubeModel::Delegator
  end

  let(:ice_cube_model) do
    ::IceCubeObjWithDelegates.new(
      :repeat_start_date => ::Date.new(2015, 6, 1),
      :repeat_day_of_month => 5,
      :repeat_hour => 0,
      :repeat_minute => 0
    )
  end

  it '#occurrences' do
    expect(ice_cube_model.occurrences(::Date.new(2015, 8, 1))).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#all_occurrences' do
    ice_cube_model.repeat_until = ::Date.new(2015, 8, 1)
    expect(ice_cube_model.all_occurrences).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#all_occurrences_enumerator' do
    ice_cube_model.repeat_until = ::Date.new(2015, 8, 1)
    expect(ice_cube_model.all_occurrences_enumerator.map { |occurrence| occurrence }).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#next_occurrences' do
    expect(ice_cube_model.next_occurrences(2, ::Date.new(2015, 6, 1))).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#next_occurrence' do
    expect(ice_cube_model.next_occurrence(::Date.new(2015, 6, 1))).to eq(::Date.new(2015, 6, 5))
  end

  it '#previous_occurrences' do
    expect(ice_cube_model.previous_occurrences(2, ::Date.new(2015, 8, 1))).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#previous_occurrence' do
    expect(ice_cube_model.previous_occurrence(::Date.new(2015, 8, 1))).to eq(::Date.new(2015, 7, 5))
  end

  it '#remaining_occurrences' do
    ice_cube_model.repeat_until = ::Date.new(2015, 8, 1)
    expect(ice_cube_model.remaining_occurrences(::Date.new(2015, 6, 1))).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#remaining_occurrences_enumerator' do
    ice_cube_model.repeat_until = ::Date.new(2015, 8, 1)
    expect(ice_cube_model.remaining_occurrences_enumerator(::Date.new(2015, 6, 1)).map { |occurrence| occurrence }).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#occurrences_between' do
    expect(ice_cube_model.occurrences_between(::Date.new(2015, 6, 1), ::Date.new(2015, 8, 1))).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#occurs_between?' do
    expect(ice_cube_model.occurs_between?(::Date.new(2015, 7, 1), ::Date.new(2015, 8, 1))).to be(true)
  end

  it '#occurring_between?' do
    expect(ice_cube_model.occurring_between?(::Date.new(2015, 6, 1), ::Date.new(2015, 8, 1))).to be(true)
  end

  it '#occurs_on?' do
    expect(ice_cube_model.occurs_on?(::Date.new(2015, 6, 5))).to be(true)
  end

  it '#occurring_at?' do
    skip 'Time options not implemented yet'
  end

  it '#conflicts_with?' do
    skip 'Time options not implemented yet'
  end

  it '#occurs_at?' do
    skip 'Time options not implemented yet'
  end

  it '#first' do
    expect(ice_cube_model.first(2)).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end

  it '#last' do
    ice_cube_model.repeat_until = ::Date.new(2015, 8, 1)
    expect(ice_cube_model.last(2)).to eq([::Date.new(2015, 6, 5), ::Date.new(2015, 7, 5)])
  end
end

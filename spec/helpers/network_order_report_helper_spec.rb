require 'rails_helper'
require 'date'


describe 'network order report helper' do

  it 'insert_defult_values_if_not_exists success for normal case' do
    array = [ {'seq' => DateTime.new(2014,1,2), 'value' => 1},
              {'seq' => DateTime.new(2014,1,4), 'value' => 2},
              {'seq' => DateTime.new(2014,1,5), 'value' => 5}]
    result = NetworkOrderReportHelper.insert_defult_values_if_not_exists(array,
                                                 'seq', 'value', DateTime.new(2014,1,1),
                                                 DateTime.new(2014,1,6), 0)
    keys = result.map { |x| x['seq'] }
    values = result.map { |x| x['value'] }

    expect(keys).to eq((DateTime.new(2014,1,1)..DateTime.new(2014,1,6)).to_a)
    expect(values).to eq([0,1,0,2,5,0])

  end
end
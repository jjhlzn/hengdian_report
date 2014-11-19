

module Hengdian
  class OrderType
    attr_accessor :id, :name
    def initialize(id, name)
      @id = id
      @name = name
    end
  end

  module Contants
    INDICATOR_PEOPLE_COUNT = 'people_count' #表示人数指标
    INDICATOR_TOTAL_MONEY = 'total_money'   #总体营收
    INDICATOR_ORDER_COUNT = 'order_count'   #订单数
  end

  ORDER_TYPE_ALL = OrderType.new('all', '全部类型')
  ORDER_TYPE_TICKET = OrderType.new('ticket', '门票')
  ORDER_TYPE_HOTEL = OrderType.new('hotel', '酒店')
  ORDER_TYPE_PACKAGE = OrderType.new('package', '套餐')
end

module TSColumns
  COL_ORDER_PEOPLE = 'DDjNumber'
  COL_ORDER_TOTAL_MONEY = 'DAmount'
end
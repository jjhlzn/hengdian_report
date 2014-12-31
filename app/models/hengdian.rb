

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

    DATETYPE_BY_COMEDATE = 'comedate'  #预达日期
    DATETYPE_BY_ORDERDATE = 'orderdate' #预订日期
  end

  ORDER_TYPE_ALL = OrderType.new('all', '全部类型')
  ORDER_TYPE_TICKET = OrderType.new('ticket', '门票')
  ORDER_TYPE_HOTEL = OrderType.new('hotel', '酒店')
  ORDER_TYPE_PACKAGE = OrderType.new('package', '套餐')

  class TicketProduction
    attr_accessor :prod_id, :name
  end
end

module TSColumns
  COL_ORDER_PEOPLE = 'DDjNumber'
  COL_ORDER_TOTAL_MONEY = 'DAmount'
  COL_ORDER_COMEDATE = 'DComeDate'
  COL_PRO_NAME = 'MyName'
end
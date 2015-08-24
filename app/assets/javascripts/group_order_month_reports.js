$(document).ready(function () {
    new LineReportChart({
        id: 'month_compare_line',
        name: '所有产品(套餐,门票,酒店)不同月份对比',
        url: '/group_order_month_reports.json',
        menus: [{type: 'indicator'}, {type: 'ordertype'}]
    }).send_request()
});


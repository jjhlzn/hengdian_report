$(document).ready(function () {
    new PieReportChart({
        id: 'production_compare_pie',
        name: '门票, 酒店, 套餐比例',
        url: '/network_order_yearly_reports.json',
        menus: [{type: 'year'}, {type: 'indicator'}]
    }).send_request()

});


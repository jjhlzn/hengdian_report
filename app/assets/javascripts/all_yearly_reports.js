$(document).ready(function () {

    new PieReportChart({
        id: 'selltype_compare_pie',
        name: '游客类型对比',
        url: '/all_yearly_reports/get_selltype_compare.json',
        menus: [{type: 'year'}, {type: 'indicator'}]
    }).send_request();



});


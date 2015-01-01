$(document).ready(function () {
    new PieReportChart({
        id: 'agent_pie',
        name: '代理商排名(门票, 酒店, 套餐)',
        height: 250,
        menus: [{type: 'year'}, {type: 'indicator'}],
        url: "network_order_yearly_agent_reports.json"}).send_request();
});



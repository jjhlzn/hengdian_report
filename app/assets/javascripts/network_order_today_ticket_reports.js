$(document).ready(function () {
    new BarReportChart({
        id: 'today_ticket_bar',
        name: '门票排行',
        height: 250,
        url: "network_order_today_ticket_reports.json"
    }).send_request();
});



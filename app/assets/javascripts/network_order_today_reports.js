$(document).ready(function () {
    new PieReportChart({
        id: 'pie_panel',
        name: '门票, 酒店, 套餐比例',
        url: '/network_order_today_reports.json'
    }).send_request()

    new LineReportChart({
        id: 'line_panel',
        name: '最近30天趋势',
        url: '/network_order_report/latest_30days_report.json'
    }).send_request()
});


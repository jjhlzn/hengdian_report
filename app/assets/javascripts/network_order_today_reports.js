$(document).ready( function() {
    var product_diff_pie_req = new PieReportChart('pie_panel', '门票, 酒店, 套餐比例', 200, 400, '/network_order_today_reports.json')
    product_diff_pie_req.params['indicator'] = 'people_count';
    product_diff_pie_req.send_request();

    var latest30_line_req = new LineReportChart('line_panel', '最近30天趋势', 200, 400, '/network_order_report/latest_30days_report.json')
    latest30_line_req.params['indicator'] = 'people_count';
    latest30_line_req.send_request();
});


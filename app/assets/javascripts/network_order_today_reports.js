var product_diff_pie_req = null;
var latest30_line_req = null;
$(document).ready( function() {
    product_diff_pie_req = new PieReportChart('pie_panel', '门票, 酒店, 套餐比例', 200, 400, 'pie', '/network_order_today_reports.json')
    product_diff_pie_req.params['indicator'] = 'people_count';
    product_diff_pie_req.send_request();

    //latest30_line_req = new LineReportChart('canvas2', 'line', '/network_order_report/latest_30days_report.json')
    //latest30_line_req.params['indicator'] = 'people_count';
    //latest30_line_req.send_request();
});


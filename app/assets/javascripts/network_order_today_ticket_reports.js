
$(document).ready( function() {
    var agent_report_req = new BarReportChart('today_ticket_bar', '门票排行',
        250, 400, "network_order_today_ticket_reports.json");
    agent_report_req.params['indicator'] = 'people_count'
    agent_report_req.send_request();
} );



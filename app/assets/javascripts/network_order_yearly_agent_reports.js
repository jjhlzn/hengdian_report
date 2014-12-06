$(document).ready( function() {
    var agent_report_req = new PieReportChart('agent_pie', '代理商排名(门票, 酒店, 套餐)', 250, 400, "network_order_yearly_agent_reports.json");
    agent_report_req.params['indicator'] = 'people_count'
    agent_report_req.send_request();
} );



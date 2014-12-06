
$(document).ready( function() {
    var today_ticket_bar = new BarReportChart()
    today_ticket_bar.params['indicator'] = 'people_count'
    today_ticket_bar.send_request()
});
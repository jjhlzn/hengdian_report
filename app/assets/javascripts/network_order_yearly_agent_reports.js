var agent_report_req = null;

function change_dataset(key, value, desc) {
    window[agent_report_req.graph_name].destroy();
    params[key] = value;
    $('#lbl_' + key).html(desc);
    $("ul.pie-legend").remove();
    agent_report_req.send();
}

$(document).ready( function() {
    agent_report_req = new PieRequest('canvas', 'pie', "network_order_yearly_agent_reports.json");
    agent_report_req.params['indicator'] = 'people_count'
    agent_report_req.send();
} );



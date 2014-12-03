function change_dataset(key, value, desc) {
    window.pie.destroy();
    params[key] = value;
    $('#lbl_' + key).html(desc);
    $("ul.pie-legend").remove();
    send_pie_data_request('canvas', 'pie', "network_order_yearly_agent_reports.json")
}

$(document).ready( function() {
    params['indicator'] = 'people_count'
    send_pie_data_request('canvas', 'pie', "network_order_yearly_agent_reports.json")
} );



/**
 * Created by jjh on 11/18/14.
 */
function send_data_request(url, params, deal_response_func) {
    $.ajax({
        type: "GET",
        url: url,
        data: params,
        dataType: "json",
        success: deal_response_func
    });
}

var COLORS = ['#659AC9', '#A0BFBE', '#ADC896', '#B58371', '#DA917A',
              '#BE98B7', '#8B814C', '#CD69C9', '#CDC673', '#EEE8CD',
              '#CD919E', '#C1CDC1', '#8B8878', '#7F7F7F', '#607B8B',
              '#4682B4', '#C67171', '#C0FF3E', '#C5C1AA', '#B9D3EE',
              '#8C8C8C']
/**
 * Created by jjh on 12/4/14.
 */
function ReportRequest(canvas_id, graph_name, url) {
    this.send = function() {
        var parent = this;
        $.ajax({
            type: "GET",
            url: this.url,
            dataType: "json",
            data: this.params,
            success:  function(respJSON, textStatus, jqXHR){
                if (respJSON.status != 0) {
                    alert('服务器返回错误（status = ' + respJSON.status + ", message = " + respJSON.message + ')');
                    return;
                }
                console.log(this.default_response_deal_function);
                parent.default_response_deal_function(respJSON, parent.canvas_id, parent.graph_name);
                if (parent.other_response_deal_function != undefined)
                    parent.other_response_deal_function(respJSON);
                console.log('ajax success function call done.')
            }
        });
    }


}

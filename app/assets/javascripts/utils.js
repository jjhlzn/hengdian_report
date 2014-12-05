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

Function.prototype.method = function (name, func) {
    if (!this.prototype[name]) {
        this.prototype[name] = func;
        return this;
    }
};

Object.create = function (o) {
    var F = function () {};
    F.prototype = o;
    return new F();
};

Function.method('new', function ( ) {
// Create a new object that inherits from the
// constructor's prototype.
    var that = Object.create(this.prototype);
// Invoke the constructor, binding –this- to
// the new object.
    var other = this.apply(that, arguments);
// If its return value isn't an object,
// substitute the new object.
    return (typeof other === 'object' && other) || that;
});

Function.method('inherits', function (Parent) {
    this.prototype = new Parent( );
    return this;
});

String.method('trim', function ( ) {
    return this.replace(/^\s+|\s+$/g, '');
});


//post方法
function postRequest(url, request, callback) {
    ajax({
        url: urlEncode(url, request),
        type: 'POST',
        data: null,
        dataType: 'json',
        contentType: 'application/json',
        success: function (data) {
            var result = eval("(" + data + ")");
            if (result.message != null && result.message !== '') {
                alert("系统提示：" + result.message);
            }
            callback(result);
        },
        error: function (xhr, error, exception) {
            alert("请求发送失败，请刷新浏览器重试或检查网络");
            alert(exception.toString());
        }
    });
}
//ajax方法
function ajaxJsonRequest(url, data, callback) {
    ajax({
        url: url,
        type: 'POST',
        data: data,
        dataType: 'json',
        contentType: 'application/json',
        success: function (data) {
            var result = eval("(" + data + ")");
            if (result.message != null && result.message !== '') {
                alert("系统提示：" + result.message);
            }
            callback(result);
        },
        error: function (xhr, error, exception) {
            alert("请求发送失败，请刷新浏览器重试或检查网络");
            alert(exception.toString());
        }
    });

}
function ajax(options) {
    options = options || {};
    options.type = (options.type || "GET").toUpperCase();
    options.async = options.async == null ? true : options.async;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            var status = xhr.status;
            if (status >= 200 && status < 300) {
                options.success && options.success(xhr.responseText, xhr.responseXML);
            } else {
                options.error && options.error(xhr.responseText, xhr.responseXML);
            }
        }
    };
    console.log("是否异步" + options.async);
    xhr.open(options.type, options.url, options.async);
    if (options.dataType != null) {
        xhr.setRequestHeader('Content-Type', options.contentType);
    }
    xhr.send(options.data);
}
function urlEncode(url, request) {
    if (request == null) return '';
    var paramStr = url + '?';
    for (var i in request) {
        if (request[i] == null) {
            continue;
        }
        paramStr += '&' + i + '=' + request[i];
    }
    return paramStr;
}

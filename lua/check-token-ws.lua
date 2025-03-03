local cjson = require "cjson"
local http = require "resty.http"

local headers = ngx.req.get_headers()
local path = ngx.var.original_uri

ngx.log(ngx.INFO, "path: ", path)

if path == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say(cjson.encode({
        error = "missing token",
        headers = headers
    }))
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end


local httpc = http.new()

httpc:set_timeouts(10000, 10000, 10000)  -- connect, send, read

local res, err = httpc:request_uri("https://realip.cc/", {
    method = "GET",
    query = {
        path = path
    },
    ssl_verify = false  -- for dev
})

if res then
    local ip_info = cjson.decode(res.body)
    ngx.log(ngx.INFO, "IP Info: ", cjson.encode(ip_info))
else
    ngx.log(ngx.ERR, "Failed to request IP info: ", err)
end

httpc:close()


if path ~= "/your_token" then
    ngx.log(ngx.INFO, "path is invalid: ", path)
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(cjson.encode({
        error = "token is invalid",
        headers = headers,
        path = path
    }))
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

ngx.log(ngx.INFO, "Request processed: ", ngx.var.request_uri)

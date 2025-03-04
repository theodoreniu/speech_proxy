local cjson = require "cjson"
local http = require "resty.http"

local headers = ngx.req.get_headers()
local path = ngx.var.original_uri
local token = string.match(path, "/([^/]+)$")

ngx.log(ngx.INFO, "path: ", path)
ngx.log(ngx.INFO, "token: ", token)

if token == nil then
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

local res, err = httpc:request_uri("https://api.github.com/repos/theodoreniu/speech_proxy", {
    method = "GET",
    query = {
        token = token
    },
    ssl_verify = false  -- for dev
})

if res and res.status == 200 then
    local ip_info = cjson.decode(res.body)
    ngx.log(ngx.INFO, "Info: ", cjson.encode(ip_info))
else
    ngx.log(ngx.ERR, "Failed to request info: ", err)
end

httpc:close()


if token ~= "your_token" then
    ngx.log(ngx.INFO, "token is invalid: ", token)
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(cjson.encode({
        error = "token is invalid",
        headers = headers,
        token = token
    }))
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

ngx.log(ngx.INFO, "Request processed: ", ngx.var.request_uri)

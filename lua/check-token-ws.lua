local jwt = require "resty.jwt"
local cjson = require "cjson"

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

local args = ngx.req.get_uri_args()

local speech_key = os.getenv("SPEECH_KEY")

ngx.log(ngx.INFO, "speech_key: ", speech_key)

if speech_key == nil then
    ngx.log(ngx.ERR, "SPEECH_KEY environment variable is not set")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

args["Ocp-Apim-Subscription-Key"] = speech_key

ngx.req.set_uri_args({})
ngx.req.set_uri_args(args)

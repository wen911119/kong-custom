local BasePlugin = require 'kong.plugins.base_plugin'
local Http2HttpsHandler = BasePlugin:extend()
Http2HttpsHandler.PRIORITY = 3000
Http2HttpsHandler.VERSION = '0.1.0'

function Http2HttpsHandler:new()
    Http2HttpsHandler.super.new(self, 'qccost-http2https')
end

function Http2HttpsHandler:access(config)
    -- Eventually, execute the parent implementation
    -- (will log that your plugin is entering this context)
    Http2HttpsHandler.super.access(self)
    local h = ngx.req.get_headers()[config.target_header_field]
    if h == 'http' then
        -- 需要跳https
        local target_url = 'https://' .. ngx.var.http_host .. ngx.var.request_uri
        ngx.redirect(target_url, ngx.HTTP_MOVED_PERMANENTLY)
    else
        return true
    end
end

return Http2HttpsHandler

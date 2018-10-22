local BasePlugin = require "kong.plugins.base_plugin"
local basic_serializer = require "kong.plugins.log-serializers.basic"
local cjson = require "cjson"

local Log2Stdout = BasePlugin:extend()

Log2Stdout.PRIORITY = 6
Log2Stdout.VERSION = "0.1.0"

local ngx_log = ngx.log
local ngx_timer_at = ngx.timer.at


local function log(premature, conf, message)
  if premature then
    return
  end
  print(conf.tag.. " " ..cjson.encode(message))
end


function Log2Stdout:new()
  Log2Stdout.super.new(self, "log2stdout")
end

function Log2Stdout:log(conf)
  Log2Stdout.super.log(self)

  local message = basic_serializer.serialize(ngx)

  local ok, err = ngx_timer_at(0, log, conf, message)
  if not ok then
    ngx_log(ngx.ERR, "failed to create timer: ", err)
  end
end

return Log2Stdout
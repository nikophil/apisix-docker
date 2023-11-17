local core         = require("apisix.core")
local consumer_mod = require("apisix.consumer")

local plugin_name = "consumer-roles"

local schema = {}

local _M = {
    version = 1.0,
    priority = 100, -- after key-auth
    name = plugin_name,
    schema = schema,
}

function _M.check_schema(conf)
    local ok, err = core.schema.check(schema, conf)
    if not ok then
        return false, err
    end

    return true
end

function _M.rewrite(conf, ctx)
    core.ctx.register_var("consumer_roles", function(ctx)
        if ctx.consumer and ctx.consumer.roles then
            return table.concat(ctx.consumer.roles, ',')
        end
        return nil
    end)
end

return _M

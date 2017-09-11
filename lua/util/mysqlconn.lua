--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 17/9/11
-- Time: 上午10:28
-- To change this template use File | Settings | File Templates.
--
local mysql = require "resty.mysql"

local config = {
    host = "localhost",
    port = 3306,
    database = "mysql",
    user = "root",
    password = "root"
}

local _M = {}


function _M.new(self)
    local db, err = mysql:new()
    if not db then
        return nil
    end
    db:set_timeout(1000) -- 1 sec

    local ok, err, errno, sqlstate = db:connect(config)

    if not ok then
        return nil
    end
    db.close = close
    return db
end

function close(self)
    local sock = self.sock
    if not sock then
        return nil, "not initialized"
    end
    if self.subscribed then
        return nil, "subscribed state"
    end
    return sock:setkeepalive(10000, 50)
end

return _M

module("luci.controller.mia",package.seeall)

function index()
	if not nixio.fs.access("/etc/config/mia") then
		return
	end

	entry({"admin", "services", "mia"}, cbi("mia"), _("Internet Access Schedule Control"), 30).dependent = true
	entry({"admin", "services", "mia", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("nft list chain inet fw4 input_lan 2>/dev/null |grep MIA >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

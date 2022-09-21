local cmd = {}
if os.getenv("QUERY_DRIVER") then
	cmd = {
		"clangd",
		"-log=verbose",
		"--query-driver=" .. os.getenv("QUERY_DRIVER"),
	}
else
	cmd = { "clangd" }
end

return {
	settings = {},
	cmd = cmd,
}

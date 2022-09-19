local status_ok, lastplace = pcall(require, "nvim-lastplace")
if not status_ok then
  return
end

lastplace.setup {}

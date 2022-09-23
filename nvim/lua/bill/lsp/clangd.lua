local cmd = {}
-- QUERY_DRIVER is like as
--    export QUERY_DRIVER=`realpath oe-workdir`/recipe-sysroot-native/usr/bin/arm-starfishmllib32-linux-gnueabi/arm-starfishmllib32-linux-gnueabi-g++
if os.getenv('QUERY_DRIVER') then
  cmd = {
    'clangd',
    '--query-driver=' .. os.getenv('QUERY_DRIVER'),
  }
else
  cmd = { 'clangd' }
end

return {
  settings = {},
  cmd = cmd,
}

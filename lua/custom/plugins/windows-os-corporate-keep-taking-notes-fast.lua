--- Problem:
---
--- For whatever reason you have to use a Windows machine on a corporate
--- environment
---
--- You take your laptop to a meeting, you open nvim and get ready to
--- take a note whenever needed.
---
--- By the time you heard something you want to take a note of, your laptop
--- locked itself because of inactivity, loosing precious time having to
--- login again.
---
--- You can't change Windows settings or when you change them they have
--- no effect because IT department is being overzealous in their
--- security measures and restrict employee changing basic OS settings.
---
--- This set of functions will keep your laptop ready to take a fast note
--- at any time.
---
--- Enjoy, taking fast notes

local is_windows = string.lower(vim.loop.os_uname().sysname) == 'windows_nt'
if (not jit) or not is_windows then
  return {}
end

local mouse_timer = vim.uv.new_timer()

local ffi = require 'ffi'

ffi.cdef [[
    typedef struct {
        long x;
        long y;
    } POINT;

    typedef struct {
        unsigned long type;
        union {
            struct {
                long dx;
                long dy;
                unsigned long mouseData;
                unsigned long dwFlags;
                unsigned long time;
                unsigned long long dwExtraInfo;
            } mi;
        };
    } INPUT;

    int SendInput(unsigned int nInputs, INPUT* pInputs, int cbSize);
    int GetCursorPos(POINT* lpPoint);
    int SetCursorPos(int X, int Y);

    uint32_t SetThreadExecutionState(uint32_t esFlags);
]]

local ES_CONTINUOUS = 0x80000000
local ES_SYSTEM_REQUIRED = 0x00000001
local ES_DISPLAY_REQUIRED = 0x00000002
local INPUT_MOUSE = 0
local MOUSEEVENTF_MOVE = 0x0001

vim.api.nvim_create_user_command('ScreenAliveOff', function()
  local kernel32 = ffi.load 'kernel32'
  local ret = kernel32.SetThreadExecutionState(bit.bor(ES_CONTINUOUS))
  if ret == 0 then
    error 'Failed to reset thread execution state'
  else
    print 'Keep screen alive OFF'
  end
  if mouse_timer and mouse_timer:is_active() then
    mouse_timer:stop()
    mouse_timer:close()
  end
end, {})

local function move_mouse_relative(dx, dy)
  local user32 = ffi.load 'user32'

  local input = ffi.new 'INPUT'
  input.type = INPUT_MOUSE
  input.mi.dx = dx
  input.mi.dy = dy
  input.mi.dwFlags = MOUSEEVENTF_MOVE

  user32.SendInput(1, input, ffi.sizeof 'INPUT')
end

vim.api.nvim_create_user_command('WiggleMouse', function()
  move_mouse_relative(1, 1)
  move_mouse_relative(-1, -1)
end, {})

vim.api.nvim_create_user_command('ScreenAliveOn', function()
  local kernel32 = ffi.load 'kernel32'
  local ret = kernel32.SetThreadExecutionState(bit.bor(ES_CONTINUOUS, ES_SYSTEM_REQUIRED, ES_DISPLAY_REQUIRED))
  if ret == 0 then
    error 'Failed to set thread execution state'
  else
    print 'Keep screen alive ON '
  end
  if mouse_timer then
    mouse_timer:start(0, 100, function()
      move_mouse_relative(1, 1)
      move_mouse_relative(-1, -1)
    end)
  end
end, {})

return {}

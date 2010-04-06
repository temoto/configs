--
-- temoto's xmonad config file.
--

import Data.Ratio ( (%) )
import System.Exit
import System.IO(hPutStrLn)

-- XMonad Core
import XMonad hiding ( (|||) )
import XMonad.Actions.SinkAll
import XMonad.Actions.WindowGo(runOrRaise)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Util.Run (spawnPipe)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = 0

myBorderWidth   = 2
myModMask       = mod4Mask
myWorkspaces    = ["code","web","sys","4","files","im","git","8","irc"]

myXftFont = "Consolas-11"
-- bg and fg colors are used by bar
myNormalBorderColor  = "#535353"
myNormalBGColor = "#333333"
myNormalFGColor = "#000000"
myFocusedBorderColor = "#dc8f1e"
myLayoutFGColor = "#506070"
myUrgentFGColor = "#0099ff"
myUrgentBGColor = "#0077ff"
myTitleColor = "#c0c0c0"
myEmptyTabBGColor = myNormalBGColor
myEmptyTabFGColor = "#909090"
myOccupiedTabBGColor = "#434343"
myOccupiedTabFGColor = "#a0a0a0"
myActiveTabBGColor = myFocusedBorderColor
myActiveTabFGColor = "#232323"
myTrayer = "trayer --edge top --align right --SetDockType true --widthtype request --transparent true --alpha 0 --tint 0x333333 --expand true --height 18 --widthtype request --distance 2 --padding 2"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $ [
    -- close focused window
    ((modMask,                 xK_c     ), kill)

    -- Set layout on current workspace
    , ((modMask,               xK_t     ), setLayout $ XMonad.layoutHook conf)
    , ((modMask,               xK_f     ), sendMessage $ JumpToLayout "Full")
    , ((modMask,               xK_g     ), sendMessage $ JumpToLayout "Grid")

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_Down  ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_Up    ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_Down  ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_Up    ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_Left  ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_Right ), sendMessage Expand)

    -- Pop window to be floating
    , ((modMask .|. shiftMask, xK_space ), withFocused $ windows . (flip W.float $ W.RationalRect 0.1687 0.2 0.662 0.6))

    -- Push window back into tiling
    , ((modMask,               xK_space ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    , ((modMask              , xK_b     ), sendMessage ToggleStruts )

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    , ((modMask .|. shiftMask, xK_t     ), sinkAll)
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F1, xK_F2, xK_F3] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Each layout is separated by |||, which denotes layout choice.
--

imLayout = avoidStruts (
                        smartBorders $ IM (1 % 5)
                        (And (ClassName "Pidgin") (Role "buddy_list"))
                       )

--gimpLayout = withIM (0.11) (Role "gimp-toolbox") $
--             reflectHoriz $
--             withIM (0.15) (Role "gimp-dock") Full

genericLayout = avoidStruts (tiled
                         ||| Full
                         ||| Grid
                         ||| simpleFloat
                         ||| imLayout
                         )

  where
     -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 1/100

myLayout = onWorkspace "im" imLayout
           $ genericLayout

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'appName' are used below.
--
myManageHook = composeAll
    [
      className =? "Ark"            --> doFloat
    , title     =? "Authorization Dialog" --> doFloat
    , appName   =? "desktop_window" --> doIgnore
    , className =? "Google-chrome"  --> doShift "web"
    , title     =? "Google Chrome Options" --> doFloat
    , appName   =? "Dialog"         --> doFloat -- firefox dialogs
    , className =? "Do"             --> doFloat
    , className =? "Dolphin"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , title     =? "Insomnia Online"--> doIgnore
    , appName   =? "kdesktop"       --> doIgnore
    , appName   =? "kvm"            --> doIgnore
    , className =? "MPlayer"        --> doFloat
    , appName   =? "npviewer.bin"   --> doIgnore
    , appName   =? "panel"          --> doIgnore
    , className =? "Pidgin"         --> doShift "im"
    , className =? "sim"            --> doShift "im"
    , className =? "Virt-manager.py"--> doFloat
    , className =? "Vlc"            --> doFloat
    , className =? "Wicd-client.py" --> doFloat
    , appName   =? "Wine"           --> doFloat
    , className =? "Wine"           --> doFloat
    , className =? "wine"           --> doFloat
    ]

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
myLogHook h = dynamicLogWithPP $ myXmobarPP h

myXmobarPP h = defaultPP {
                     ppCurrent = xmobarColor myActiveTabFGColor myActiveTabBGColor . pad
                   , ppSep     = ""
                   , ppWsSep   = ""
                   , ppVisible = xmobarColor myOccupiedTabFGColor myOccupiedTabBGColor . pad
                   , ppLayout  = xmobarColor myLayoutFGColor myNormalBGColor . pad
                   , ppTitle   = xmobarColor myTitleColor myNormalBGColor . shorten 83
                   , ppHiddenNoWindows =
                                 xmobarColor myEmptyTabFGColor myEmptyTabBGColor . pad
                   , ppHidden  = xmobarColor myOccupiedTabFGColor myOccupiedTabBGColor . pad
                   , ppOutput  = hPutStrLn h
                   }

main = do
     pipe <- spawnPipe "xmobar ~/.xmonad/xmobar"
     spawn "killall -9 trayer"
     spawn myTrayer
     xmonad $ defaults pipe

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults pipe = defaultConfig {
      -- simple stuff
--        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook pipe
    }

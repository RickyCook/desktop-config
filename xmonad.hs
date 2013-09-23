-- ~/.xmonad/xmonad.hs
----------------------------
-- Imports {{{
import System.Exit
import System.IO

import XMonad

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)

-- Hooks
--import XMonad.Operations
import XMonad.Util.Run
import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
--import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
--import XMonad.Hooks.FadeInactive
--import XMonad.Hooks.EwmhDesktops

--import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
--import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
--import XMonad.Layout.LayoutHints
--import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import XMonad.Layout.ComboP
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane

import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- Bar
import DBus.Client
import System.Tianbar.XMonadLog

--}}}

----------------------------
-- Config {{{
-- Define Terminal
myTerminal = "x-terminal-emulator"

-- Define modMask
modMask' :: KeyMask
modMask' = mod4Mask

-- Define workspaces
myWorkspaces = ["1:code","2:terminal","3:web","4:mail","5:chat","6:media"]

-- Directories
myHomeDir     = "/home/ricky/"
myCabalBinDir = myHomeDir ++ ".cabal/bin/"
myXInitDDir   = myHomeDir ++ "xinit.d/"

-- Define commands
shBackground = "/usr/bin/nitrogen --restore"    -- Set the background
shCursor     = "xsetroot -cursor_name left_ptr" -- Fix the default cursor
shBar        = myCabalBinDir ++ "tianbar"
shRestartWM  = "killall tianbar && " ++ myCabalBinDir ++ "xmonad --recompile && " ++ myCabalBinDir ++ "xmonad --restart"
shStartup    = "find -L '" ++ myXInitDDir ++ "' -executable ! -type d -print0 | xargs -0 -n 1 bash -c 'exec \"$0\" &'"

-- Define theme things
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorElecBlue       = "#3ECAE8"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"

colorNormalBorder   = colorWhite
colorFocusedBorder  = colorElecBlue
colorDefaultText    = colorElecBlue

fontDefault = "xft:Source Code Pro ExtraLight:style=ExtraLight:size=10"
fontBar     = fontDefault

--}}}

----------------------------
-- Main {{{
main = do
    -- DBus
    client <- connectSession

    -- Startup
    spawnPipe shBackground
    spawnPipe shCursor
    spawnPipe shBar
    spawnPipe shStartup

    -- Config
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
        { terminal           = myTerminal
        , workspaces         = myWorkspaces
        , keys               = keys'
        , modMask            = modMask'
        , layoutHook         = avoidStruts $ layoutHook'
        , logHook            = dbusLog client
        , manageHook         = manageDocks <+> manageHook'
        , normalBorderColor  = colorNormalBorder
        , focusedBorderColor = colorFocusedBorder
        , borderWidth        = 2
        }
--}}}

----------------------------
-- Theme {{{
theme :: Theme
theme = defaultTheme { urgentTextColor = colorOrange
                     , urgentBorderColor = colorOrange
                     , fontName = fontDefault
                     }
--}}}

----------------------------
-- Hooks {{{
-- ManageHook
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1:code"   |   c   <- myCode   ] -- move code to main
    , [className    =? c            --> doShift  "3:web"    |   c   <- myWeb    ] -- move web to main
    , [className    =? c            --> doShift  "4:mail"   |   c   <- myMail   ] -- move mail to main
    , [className    =? c            --> doShift	 "5:chat"   |   c   <- myChat   ] -- move chat to chat
    , [className    =? c            --> doShift  "6:media"  |   c   <- myMedia  ] -- move media to media
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
--    , [role         =? n            --> doCenterFloat       |   n   <- myFloatRoles  ] -- float my roles
    , [isFullscreen                 --> myDoFullFloat                           ]
    ]) 

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myFloats  = ["Smplayer","MPlayer","VirtualBox","Xmessage","XFontSel","Downloads","Nm-connection-editor"]
        myCode    = ["Sublime Text 2"]
        myWeb     = ["Firefox","Google-chrome","Chromium", "Chromium-browser"]
        myMail	  = ["Icedove"]
        myChat	  = ["Pidgin","Buddy List"]
        myMedia	  = ["Rhythmbox","Spotify","Totem"]

        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]
        myFloatRoles = ["AlarmWindow"]

-- ManageHook (Full Screen)
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat

--layoutHook'  =  onWorkspaces ["1:main","5:music"] customLayout $ 
--                onWorkspaces ["6:gimp"] gimpLayout $ 
--                onWorkspaces ["4:chat"] imLayout $
--                customLayout2

-- Bar

-- Layout
--customLayout = avoidStruts $ tiled ||| Mirror tiled ||| Full ||| simpleFloat
--  where
--    tiled   = ResizableTall 1 (2/100) (1/2) []

--customLayout2 = avoidStruts $ Full ||| tiled ||| Mirror tiled ||| simpleFloat
--  where
--    tiled   = ResizableTall 1 (2/100) (1/2) []

--gimpLayout  = avoidStruts $ withIM (0.11) (Role "gimp-toolbox") $
--              reflectHoriz $
--              withIM (0.15) (Role "gimp-dock") Full

--myRooms = ["devops","offtopic","s2s","wsx"]

--floatLayout  = named "Float" $ simpleFloat' shrinkText theme
tabbedLayout = named "Tabbed" $ tabbed shrinkText theme
mosaicLayout = named "Mosaic" $ MosaicAlt M.empty

chatsLayout = combineTwoP (TwoPane 0.03 0.5) individualChatsLayout groupChatsLayout isGroupChat
    where individualChatsLayout = tabbedLayout
          groupChatsLayout = tabbedLayout
          isGroupChat = foldl1 Or $ map Title ["devops", "s2s", "qipps", "iss", "wsx", "#zato"]

imLayout = named "IM" $
    combineTwoP (TwoPane 0.03 0.2) rosterLayout mainLayout isRoster
    where rosterLayout = mosaicLayout
          mainLayout   = chatsLayout
          isRoster     = pidginRoster `Or` skypeRoster
          pidginRoster = ClassName "Pidgin" `And` Role "buddy_list"
          skypeRoster  = ClassName "skype" `And` Not(Role "ConversationsWindow")

layoutHook' = 
        onWorkspaces ["5:chat"] imLayout $
        mosaicLayout ||| tabbedLayout
--}}}

----------------------------
-- Prompt Config {{{
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = fontBar
                    , bgColor               = colorDarkGray
                    , fgColor               = colorDefaultText
                    , bgHLight              = colorDefaultText
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 14
                    , historyFilter         = deleteConsecutive
                    }
-- }}}

----------------------------
-- Key mapping {{{
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_F2       ), runOrRaisePrompt mXPConfig)
    , ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask,      xK_c        ), kill)

    -- Programs
    , ((0,                          xK_Print    ), spawn "xmessage $(ss-capture.sh full)")
    , ((shiftMask,                  xK_Print    ), spawn "xmessage $(ss-capture.sh partial)")
    , ((modMask,                    xK_Print    ), spawn "ss-gyazo-browser.sh full")
    , ((modMask .|. shiftMask,      xK_Print    ), spawn "ss-gyazo-browser.sh full")
    , ((modMask,		            xK_o        ), spawn "chrome")
    , ((modMask,                    xK_m        ), spawn "thunar")

    -- Media Keys
    , ((0,                          0x1008ff12  ), spawn "amixer -q sset Headphone toggle")        -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -q sset Headphone 5%-")   -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -q sset Headphone 5%+")   -- XF86AudioRaiseVolume
    , ((0,                          0x1008ff14  ), spawn "rhythmbox-client --play-pause")
    , ((0,                          0x1008ff17  ), spawn "rhythmbox-client --next")
    , ((0,                          0x1008ff16  ), spawn "rhythmbox-client --previous")

    -- Layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_n        ), refresh)
    , ((modMask,                    xK_j        ), windows W.focusDown)
    , ((modMask,                    xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    --, ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    --, ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    --, ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    --, ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))


    -- Workspaces
    , ((modMask .|. controlMask,   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)

    -- Quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn shRestartWM)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

--}}}

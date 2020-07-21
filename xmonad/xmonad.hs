-- Xmonad is a dynamically tiling X11 window manager that is written and
-- configured in Haskell. Official documentation: https://xmonad.org

-- This is the xmonad configuration of Derek Taylor (DistroTube)
-- My YouTube: http://www.youtube.com/c/DistroTube
-- My GitLab:  http://www.gitlab.com/dwt1/

-- This config was getting massively long, so I have made this a modular
-- config that sources multiple config files. Look under the imports for
-- "Custom" modules. Those are my config files and they can be found in:
-- ~/.xmonad/lib/Custom

-- Keep in mind, that my configs are purposely bloated with examples of
-- what you can do with xmonad. It is written more as a study guide rather
-- than a config that you should download and use.

------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------

    -- Custom (my personal configs)
-- import Custom.MyGridMenu
-- import Custom.MyKeys
-- import Custom.MyPrompts
-- import Custom.MyScratchpads
-- import Custom.MyTreeMenu
-- import Custom.MyVariables

    -- Base
import XMonad
import Data.Monoid
import System.IO (hPutStrLn)
import XMonad.Actions.MouseResize

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

    -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------
-- AUTOSTART
------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
          spawnOnce "nitrogen --restore &"
          spawnOnce "picom &"
          spawnOnce "nm-applet &"
          spawnOnce "volumeicon &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x292d3e --height 22 &"
          spawnOnce "/usr/bin/emacs --daemon &"
          -- spawnOnce "kak -d -s mysession &"
          setWMName "LG3D"

------------------------------------------------------------------------
-- MENUS FOR GRIDSELECT AND TREESELECT
------------------------------------------------------------------------
-- The lists below are actually 3-tuples for use with gridSelect and treeSelect.
-- TreeSelect uses all three values in the 3-tuples but GridSelect only needs first
-- two values in each list (see myAppGrid, myBookmarkGrid and myConfigGrid below).


myBookmarks :: [(String, String, String)]
myBookmarks = [ ("DistroTube.com", myBrowser ++ "https://www.distrotube.com", "Official website for DistroTube")
              , ("DistroWatch", myBrowser ++ "https://www.distrowatch.com", "DistroWatch Release Announcements")
              , ("Arch Linux", myBrowser ++ "https://www.archlinux.org/", "Official website for Arch Linux")
              , ("Arch User Repository", myBrowser ++ "https://aur.archlinux.org/", "The Arch User Repository AUR")
              , ("Arch Wiki", myBrowser ++ "https://wiki.archlinux.org/", "The Arch Wiki")
              , ("LBRY", myBrowser ++ "https://lbry.tv/@DistroTube:2", "DistroTube on LBRY")
              , ("GitLab", myBrowser ++ "https://gitlab.com/dwt1", "GitLab Page for DistroTube")
              , ("Patreon", myBrowser ++ "https://www.patreon.com/distrotube", "DT on Patreon")
              , ("Diaspora", myBrowser ++ "https://diasp.org/stream", "DT on Diaspora")
              , ("Mastodon", myBrowser ++ "https://mastodon.technology/web/accounts/85897", "DT on Mastodon")
              , ("Reddit", myBrowser ++ "https://www.reddit.com/r/distrotube/", "r/DistroTube")
              , ("YouTube", myBrowser ++ "https://www.youtube.com/c/DistroTube?view_as=subscriber", "DT on YouTube")
              ]

------------------------------------------------------------------------
-- WORKSPACES
------------------------------------------------------------------------
-- My workspaces are clickable meaning that the mouse can be used to switch
-- workspaces. This requires xdotool. You need to use UnsafeStdInReader instead
-- of simply StdInReader in xmobar config so you can pass actions to it. Also,
-- you will notice I add <fn> tags to the clickable workspaces to select from
-- the additionalFonts that I have set in my xmobar configs.

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               -- $ ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
               $ ["dev", "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ "> " ++ ws ++ " </action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

------------------------------------------------------------------------
-- MANAGEHOOK
------------------------------------------------------------------------
-- Sets some rules for certain programs. Examples include forcing certain
-- programs to always float, or to always appear on a certain workspace.
-- Forcing programs to a certain workspace with a doShift requires xdotool
-- if you are using clickable workspaces. You need the className or title
-- of the program. Use xprop to get this info.

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out
     -- the full name of my workspaces.
     [ className =? "obs"     --> doShift ( myWorkspaces !! 7 )
     , title =? "firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"     --> doShift ( myWorkspaces !! 7 )
     , className =? "vlc"     --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"    --> doShift ( myWorkspaces !! 8 )
     , className =? "Gimp"    --> doFloat
     , title =? "Oracle VM VirtualBox Manager"     --> doFloat
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- LOGHOOK
------------------------------------------------------------------------
-- Sets opacity for inactive (unfocused) windows. I prefer to not use
-- this feature so I've set opacity to 1.0. If you want opacity, set
-- this to a value of less than 1 (such as 0.9 for 90% opacity).
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ mySpacing' 4
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = "xft:Mononoki Nerd Font:regular:pixelsize=11"
                      , activeColor         = "#292d3e"
                      , inactiveColor       = "#3e445e"
                      , activeBorderColor   = "#292d3e"
                      , inactiveBorderColor = "#292d3e"
                      , activeTextColor     = "#ffffff"
                      , inactiveTextColor   = "#d0d0d0"
                      }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Sans:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 -- ||| grid
                                 ||| noBorders tabs
                                 -- ||| spirals
                                 -- ||| threeCol
                                 -- ||| threeRow

------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------
main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 /home/dt/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/dt/.config/xmobar/xmobarrc2"
    xmproc2 <- spawnPipe "xmobar -x 2 /home/dt/.config/xmobar/xmobarrc1"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys


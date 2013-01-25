import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Solarized


-- myManageHook = composeAll (
--     [ manageHook gnomeConfig
--     , className =? "Unity-2d-panel" --> doIgnore
--     , className =? "Unity-2d-launcher" --> doFloat
--     ])


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
    xmonad $ defaultConfig
        { normalBorderColor = solarizedBase01
        , focusedBorderColor = solarizedRed
        , manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput =hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask  -- Rebind Mod to Windows (aka Super) key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
        , ((mod4Mask, xK_F8), lowerVolume 3 >> return ())
        , ((mod4Mask, xK_F9), raiseVolume 3 >> return ())
--      , ((mod4Mask, xK_F10), toggleMute    >> return ())
        ]

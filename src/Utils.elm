module Utils exposing (onRightClick)

-- onRightClick

type alias onRightClickOptions =
    { stopPropagation : Bool
    , preventDefault : Bool
    }


onRightClick : onRightClickOptions
onRightClick = 
    { stopPropagation : False
    , preventDefault : True
    }


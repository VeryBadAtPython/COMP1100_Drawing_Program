--- Copyright 2022 The Australian National University, All rights reserved

module View where

import CodeWorld
import Data.Text (pack)
import Model

-- | Render all the parts of a Model to a CodeWorld picture.
-- | You do not need to understand all parts of this function.
modelToPicture :: Model -> Picture
modelToPicture (Model ss t c)
  = translated 0 8 toolText
  & translated 0 7 colourText
  & translated 0 (-8) areaText
  & colourShapesToPicture ss
  & coordinatePlane
  where
    colourText = stringToText (show c)
    toolText = stringToText (toolToLabel t)
    areaText = stringToText (case t of
      RectangleTool r _ -> "Current scaling factor: " ++
        takeWhile (/='.') (show r) ++ take 2 (dropWhile (/='.') (show r))
      _ -> "")
    stringToText = lettering . pack

-- TODO
toolToLabel :: Tool -> String
toolToLabel = undefined

-- TODO
colourShapesToPicture :: [ColourShape] -> Picture
colourShapesToPicture = undefined

-- TODO
colourShapeToPicture :: ColourShape -> Picture
colourShapeToPicture = undefined

-- TODO
colourNameToColour :: ColourName -> Colour
colourNameToColour = undefined

-- TODO
shapeToPicture :: Shape -> Picture
shapeToPicture = undefined
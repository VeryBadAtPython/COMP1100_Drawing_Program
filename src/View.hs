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






-- Task 1A
toolToLabel :: Tool -> String
toolToLabel tool = case tool of
  LineTool _            -> "Line: click-drag-release"
  PolygonTool _         -> "Polygon: click 3 or more times then spacebar"
  CircleTool _          -> "Circle: click-drag-release between centre and circumference"
  TriangleTool _        -> "Triangle: click-drag release for first 2 corners"
  RectangleTool _ _     -> "Rectangle: +/- to increase/decrease scaling factor; click-drag release for first 2 corners"
  CapTool _ _           -> "Cap: click-drag-release for circle, then click for cap level"





-- Task 2A
colourNameToColour :: ColourName -> Colour
colourNameToColour name = case name of
 Black  -> black
 Red    -> red
 Orange -> orange
 Yellow -> yellow
 Green  -> green
 Blue   -> blue
 Purple -> purple
 White  -> white



-- Task 2B
distance :: Point -> Point -> Double
distance (x1,y1) (x2,y2) = sqrt(((x2-x1)**2)+((y2-y1)**2))

otherTriPoint :: Point -> Point -> Point
otherTriPoint (x1,y1) (x2,_) = (2*x2-x1,y1)

shapeToPicture :: Shape -> Picture
shapeToPicture shape = case shape of
  Line point1 point2            -> polyline [point1,point2]
  Polygon pointlist             -> solidPolygon pointlist
  Circle (a,b) circum           -> translated a b (solidCircle (distance (a,b) circum))
  Triangle point1 point2        -> solidPolygon [point1, point2, (otherTriPoint point1 point2)]
  Rectangle k (x1,y1) (x2,y2)   -> solidPolygon [(x1,y1), (x2,y2), (x2+k*(y2-y1),y2+k*(x1-x2)), (x1+k*(y2-y1),y1+k*(x1-x2))]
  Cap point1 point2 factor      -> undefined



-- TASK 2C
colourShapeToPicture :: ColourShape -> Picture
colourShapeToPicture colourshape = case colourshape of
 (shape,Black)   -> coloured black (shapeToPicture shape)
 (shape,Red)     -> coloured red (shapeToPicture shape)
 (shape,Orange)  -> coloured orange (shapeToPicture shape)
 (shape,Yellow)  -> coloured yellow (shapeToPicture shape)
 (shape,Green)   -> coloured green (shapeToPicture shape)
 (shape,Blue)    -> coloured blue (shapeToPicture shape)
 (shape,Purple)  -> coloured purple (shapeToPicture shape)
 (shape,White)   -> coloured white (shapeToPicture shape)



-- TASK 2D
colourShapesToPicture :: [ColourShape] -> Picture
colourShapesToPicture list = case list of
    [x]  -> colourShapeToPicture x
    x:xs -> (colourShapeToPicture x) & (colourShapesToPicture xs)
    _    -> error "No matching case for given list of colourshapes"
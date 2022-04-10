--- Copyright 2022 The Australian National University, All rights reserved
-- Jacob Bos u7469354, 2022, Assignment 1

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

-- / colour name to the colour
-- >>> colourNameToColour Black
-- black
--
-- >>> colourNameToColour Blue
-- blue

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

-- / Distance test
--
-- >>> distance (1,1) (1,2)
-- 1

distance :: Point -> Point -> Double
distance (x1,y1) (x2,y2) = sqrt(((x2-x1)**2)+((y2-y1)**2))

-- / Other triangle point test
--
-- >>> otherTriPoint (1,1) (2,2)
-- (3.0,1.0)

otherTriPoint :: Point -> Point -> Point
otherTriPoint (x1,y1) (x2,_) = (2*x2-x1,y1)

-- /Shape to pic test
--
-- >>> shapeToPicture Line (1,1) (1,2)
-- polyline [(1,1),(1,2)]
--
-- >>> shapeToPicture Circle (1,1) (1,2)
-- translated 1 1 (solidCircle 2)

shapeToPicture :: Shape -> Picture
shapeToPicture shape = case shape of
  Line point1 point2            -> polyline [point1,point2]
  Polygon pointlist             -> solidPolygon pointlist
  Circle (x1,y1) (x2,y2)        -> translated x1 y1 (solidCircle (distance (x1,y1) (x2,y2)))
  Triangle point1 point2        -> solidPolygon [point1, point2, (otherTriPoint point1 point2)]
  Rectangle k (x1,y1) (x2,y2)   -> solidPolygon [(x1,y1), (x2,y2), (x2+k*(y2-y1),y2+k*(x1-x2)), (x1+k*(y2-y1),y1+k*(x1-x2))]
  Cap (x1,y1) (x2,y2) ycoord
    | (ycoord > (y1-dist))      -> translated x1 (ycoord+dist) (clipped (2*dist) (2*dist) (translated 0 (y1-ycoord-dist) (solidCircle dist)))
    | otherwise                 -> translated x1 y1 (solidCircle dist)
    where dist = distance (x1,y1) (x2,y2)



-- TASK 2C

-- / Test of colourshape to picture
--
-- >>> colourShapeToPicture ((Line (1,1) (1,2)), Black)
-- coloured black (polyline [(1,1),(1,2)])


colourShapeToPicture :: ColourShape -> Picture
colourShapeToPicture (shape,colour) = coloured (colourNameToColour colour) (shapeToPicture shape)

-- TASK 2D

-- / Test of colourshapes to picture
--
-- >>> colourShapesToPicture [((Line (1,1) (1,2)), Black)]
-- [coloured black (polyline [(1,1),(1,2)])]
--
-- >>> colourShapesToPicture []
-- blank

colourShapesToPicture :: [ColourShape] -> Picture
colourShapesToPicture list = case list of
    []   -> blank
    [x]  -> colourShapeToPicture x
    x:xs -> (colourShapeToPicture x) & (colourShapesToPicture xs)

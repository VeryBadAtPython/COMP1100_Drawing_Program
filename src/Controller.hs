--- Copyright 2022 The Australian National University, All rights reserved

module Controller where

import CodeWorld
import Model

import Data.Text (pack, unpack)

-- | TASK 3 Compute the new Model in response to an Event.
handleEvent :: Event -> Model -> Model
handleEvent event (Model shapes tool colour) =
  case event of
    KeyPress key
      | k == "Esc"                        -> startModel -- revert to an empty canvas
      | k == "D"                          -> trace (pack (show currentModel)) currentModel -- write the current model to the console
      | k == "S"                          -> Model sample tool colour -- display the mystery image
      | k == "Backspace" || k == "Delete" -> deletePress (Model shapes tool colour) -- Calls helper
      | k == " "                          -> endPoly (Model shapes tool colour) -- Calls helper
      | k == "T"                          -> Model shapes (nextTool tool) colour
      | k == "C"                          -> Model shapes tool (nextColour colour)
      | k == "+" || k == "="              -> scaleRect (Model shapes tool colour) -- Calls helper
      | k == "-" || k == "_"              -> negScaleRect (Model shapes tool colour) -- Calls helper
      | otherwise -> currentModel -- ignore other keys
      where
        k = unpack key

    PointerPress p -> pointPress (Model shapes tool colour) p -- Part 3A1
    PointerRelease p -> pointRel (Model shapes tool colour) p -- Part 3A2
    _ -> currentModel -- ignore other events

    where
     currentModel = Model shapes tool colour

 -- HELPER FUNCTIONS for Part 3

deletePress  :: Model -> Model
deletePress (Model shapes tool colour) = case shapes of
  []    -> (Model shapes tool colour)  -- Prevents crash on empty shapes list
  [_]   -> Model [] tool colour        -- Deletes only element
  _:xs  -> Model xs tool colour        -- Deletes last added element

endPoly :: Model -> Model
endPoly (Model shapes tool colour) = case tool of
  PolygonTool list -> Model (((Polygon list) , colour):shapes) (PolygonTool []) colour -- Adds polygontool to the list of shapes when spacebar
  _                -> (Model shapes tool colour)

scaleRect :: Model -> Model
scaleRect (Model shapes tool colour) = case tool of
  RectangleTool x Nothing -> Model shapes (RectangleTool (x+0.1) Nothing) colour -- Increments rect scale +0.1
  _                       -> (Model shapes tool colour)

negScaleRect :: Model -> Model
negScaleRect (Model shapes tool colour) = case tool of
  RectangleTool x Nothing -> Model shapes (RectangleTool (x-0.1) Nothing) colour -- Inc rect scale factor -0.1
  _                       -> (Model shapes tool colour)

pointPress :: Model -> Point -> Model
pointPress (Model shapes tool colour) (x,y) = case tool of
  (LineTool Nothing)            -> Model shapes (LineTool (Just (x,y))) colour
  (PolygonTool list)            -> Model shapes (PolygonTool ((x,y):list)) colour
  (CircleTool Nothing)          -> Model shapes (CircleTool (Just (x,y))) colour
  (TriangleTool Nothing)        -> Model shapes (TriangleTool (Just (x,y))) colour
  (RectangleTool scale Nothing) -> Model shapes (RectangleTool scale (Just (x,y))) colour
  (CapTool Nothing Nothing)     -> Model shapes (CapTool (Just (x,y)) Nothing) colour
  _                             -> (Model shapes tool colour)

pointRel :: Model -> Point -> Model
pointRel (Model shapes tool colour) (x,y) = case tool of
  (LineTool (Just k))             -> Model (((Line k (x,y)),colour):shapes) (LineTool Nothing) colour
  (PolygonTool list)              -> Model shapes (PolygonTool ((x,y):list)) colour
  (CircleTool (Just k))           -> Model (((Circle k (x,y)),colour):shapes) (CircleTool Nothing) colour
  (TriangleTool (Just k))         -> Model (((Triangle k (x,y)),colour):shapes) (TriangleTool Nothing) colour
  (RectangleTool scale (Just k))  -> Model (((Rectangle scale k (x,y)),colour):shapes) (RectangleTool 1 Nothing) colour
  (CapTool (Just k) Nothing)      -> Model shapes (CapTool (Just k) (Just (x,y))) colour
  (CapTool (Just k) (Just m))     -> Model (((Cap k m y),colour):shapes) (CapTool Nothing Nothing) colour
  _                               -> (Model shapes tool colour)


-- Task 1B
nextColour :: ColourName -> ColourName
nextColour colour = case colour of
 Black  -> Red
 Red    -> Orange
 Orange -> Yellow
 Yellow -> Green
 Green  -> Blue
 Blue   -> Purple
 Purple -> White
 White  -> Black

-- Task 1C
  -- If holding nothing select next tool in following sequence otherwise return argument unchanged
  -- Line -> Polygon -> Circle -> Triangle -> Rectangle-> Cap -> Line
nextTool :: Tool -> Tool
nextTool tool = case tool of
 (PolygonTool [])                -> (CircleTool Nothing)
 (LineTool Nothing)              -> (PolygonTool [])
 (CircleTool Nothing)            -> (TriangleTool Nothing)
 (TriangleTool Nothing)          -> (RectangleTool 1 Nothing)
 (RectangleTool _ Nothing)       -> (CapTool Nothing Nothing)
 (CapTool Nothing Nothing)       -> (LineTool Nothing)
 _                               -> tool  


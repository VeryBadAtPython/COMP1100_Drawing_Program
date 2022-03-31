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
      | k == "Esc" -> startModel -- revert to an empty canvas
      | k == "D" -> trace (pack (show currentModel)) currentModel -- write the current model to the console
      | k == "S" -> Model sample tool colour -- display the mystery image

      | k == "Backspace" || k == "Delete" -> case shapes of
        []    -> currentModel         -- Prevents crash on empty shapes list
        [_]   -> Model [] tool colour -- Deletes only element
        _:xs  -> Model xs tool colour -- Deletes last added element

      | k == " " -> case tool of
        PolygonTool list -> Model (((Polygon list) , colour):shapes) (PolygonTool []) colour -- Adds polygontool to the list of shapes when spacebar
        _                     -> currentModel
   
      | k == "T" -> Model shapes (nextTool tool) colour
      | k == "C" -> Model shapes tool (nextColour colour)

      | k == "+" || k == "=" -> case tool of
        RectangleTool x (Just point) -> Model shapes (RectangleTool (x+0.1) (Just point)) colour -- Increments rect scale +0.1
        _                            -> currentModel
      | k == "-" || k == "_" -> case tool of
        RectangleTool x (Just point) -> Model shapes (RectangleTool (x-0.1) (Just point)) colour -- Inc rect scale factor -0.1
        _                            -> currentModel

      -- ignore other keys
      | otherwise -> currentModel

      where
        k = unpack key

    PointerPress p -> undefined  -- TODO

    PointerRelease p -> undefined  -- TODO
    
    -- ignore other events
    _ -> currentModel

    where
     currentModel = Model shapes tool colour





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


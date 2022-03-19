--- Copyright 2022 The Australian National University, All rights reserved

module Controller where

import CodeWorld
import Model

import Data.Text (pack, unpack)

-- | Compute the new Model in response to an Event.
handleEvent :: Event -> Model -> Model
handleEvent event (Model shapes tool colour) =
  case event of
    KeyPress key
      -- revert to an empty canvas
      | k == "Esc" -> startModel

      -- write the current model to the console
      | k == "D" -> trace (pack (show currentModel)) currentModel

      -- display the mystery image
      | k == "S" -> Model sample tool colour

      | k == "Backspace" || k == "Delete" -> undefined  -- TODO

      | k == " " -> undefined  -- TODO
   
      | k == "T" -> undefined  -- TODO

      | k == "C" -> undefined  -- TODO

      | k == "+" || k == "=" -> undefined  -- TODO

      | k == "-" || k == "_" -> undefined  -- TODO

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
-- (ERROR Recieved) 
  -- src\Controller.hs:74:44: error:
  --  * Couldn't match expected type `Tool'
  --                with actual type `Maybe Point -> Tool'
  --  * Probable cause: `LineTool' is applied to too few arguments
  --    In the expression: LineTool
  --    In an equation for `nextTool':
nextTool :: Tool -> Tool
nextTool tool = case tool of
 (PolygonTool [])                -> (CircleTool Nothing)
 (LineTool Nothing)              -> (PolygonTool [])
 (CircleTool Nothing)            -> (TriangleTool Nothing)
 (TriangleTool Nothing)          -> (RectangleTool 1 Nothing)
 (RectangleTool _ Nothing)       -> (CapTool Nothing Nothing)
 (CapTool Nothing Nothing)       -> (LineTool Nothing)
 tool                            -> tool  
--tool 
  -- |tool == (PolygonTool [])                = CircleTool Nothing
  -- |tool == (LineTool Nothing)              = PolygonTool []
  -- |tool == (CircleTool Nothing)            = TriangleTool Nothing
  -- |tool == (TriangleTool Nothing)          = RectangleTool Nothing Nothing
  -- |tool == (RectangleTool Nothing Nothing) = CapTool Nothing Nothing
  -- |tool == (CapTool Nothing Nothing)       = LineTool
  -- |otherwise                               = tool


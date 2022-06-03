

In this assignment, you will build a Haskell program that uses the
[CodeWorld API](https://hackage.haskell.org/package/codeworld-api-0.6.0/docs/CodeWorld.html) to draw colourful shapes on the screen.


## Overview of Tasks


<table>
  <thead>
    <tr>
      <th> </th>
      <th><strong>COMP1100 Marks</strong></th>
      <th><strong>COMP1130 Marks</strong></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Task 1: Helper Functions</td>
      <td>20 marks</td>
      <td>10 marks</td>
    </tr>
    <tr>
      <td>Task 2: Rendering Shapes</td>
      <td>35 Marks</td>
      <td>30 Marks</td>
    </tr>
    <tr>
      <td>Task 3: Handling Events</td>
      <td>30 Marks</td>
      <td>25 Marks</td>
    </tr>
    <tr>
      <td>1130 Extensions</td>
      <td>-</td>
      <td>30 Marks</td>
    </tr>
    <tr>
      <td>Technical Report</td>
      <td>15 marks</td>
      <td>25 marks</td>
    </tr>
    <tr>
      <td>Total</td>
      <td>100 marks</td>
      <td>120 marks</td>
    </tr>
  </tbody>
</table>

## Overview of the Repository

Most of your code will be written to Haskell files in the `src/`
directory. We are using the
[model-view-controller](https://en.wikipedia.org/wiki/Model–view–controller)
pattern to structure this assignment. Each file is called a _module_,
and we use modules to group related code together and separate
unrelated code.

### Model.hs

The _model_ is a data type that describes the state of the running
program. The program will move to new states (new values of type
`Model`) in response to user actions, as defined by the
_controller_.

### View.hs

The _view_ turns the _model_ into something that can be shown on the
screen; in this project, that is the CodeWorld `Picture` type.

### Controller.hs

The _controller_ considers user input (and other events), along with
the current _model_, and uses that to decide what the new _model_
should be.

### Other Files

* `tests/ShapesTest.hs` contains some _unit tests_ - simple checks
  that verify small parts of your program are working correctly. You
  are not required to write tests for this assignment, but you might
  find it useful to do so.

* `tests/Testing.hs` is a small testing library used by
  `tests/ShapesTest.hs`. You are not required to understand it for
  this assignment.

* `app/Main.hs` ties your functions together into the final program
  that runs. You are not required to understand it.

* `comp1100-assignment1.cabal` tells the cabal build tool how to build
  your assignment. You are not required to understand this file, and
  we will discuss how to use cabal below.

* `Setup.hs` tells cabal that this is a normal package with no unusual
  build steps. Some complex packages (that we won't see in this
  course) need to put more complex code here. You are not required to
  understand it.


## Overview of Cabal

`cabal` is the build tool for Haskell programs and libraries. It
provides several useful commands:

* `cabal v2-build`: Compile your assignment. Note that because of some code
  provided for you by us you will see some warnings about unused variables; you will
  fix these warnings during Task B, so may ignore them for Task A.

* `cabal v2-run shapes`: Build your assignment (if necessary), and run
  the `shapes` program. Note that you will need to enter `Ctrl-C` in your terminal
  to exit the program.

* `cabal v2-repl comp1100-assignment1`: Run the GHCi interpreter over
  your project. This gives you the same ghci environment you use in
  labs, but with the assignment code loaded. (Aside: REPL is the name
  for interactive sessions like GHCi - it stands for read-eval-print
  loop. Many modern languages have REPLs.)

* `cabal v2-test`: Build and run the tests. Tests will abort on the first
  failure, or the first call to a function that is still `undefined`.

{:.msg-info}
You should execute these cabal commands in the **top-level directory** of your
project, e.g. `~/comp1100/assignments/Assignment1` (i.e., the directory you are in when you
launch the VSCodium Terminal for your project).


## Overview of the Program

You use a web browser to interact with the `shapes` program that you
launched with `cabal v2-run shapes`. Once you have completed the
assignment, it will respond to the following actions:

| Action                     | Effect                                                                            |
|----------------------------|-------------------------------------------------------------|
| `Esc` (key)                | Clear the canvas                                            |
| `S` (key)                  | Display a sample image                                      |
| `C` (key)                  | Change colour (of shape to draw)                            |
| `T` (key)                  | Change tool (type of shape to draw)                         |
| `Backspace`/`Delete` (key) | Remove the last added shape                                 |
| `Spacebar` (key)           | When drawing a polygon, finish drawing the polygon, adding it to the canvas. Otherwise, nothing.                                                      |
| `+`/`=` (key)              | Increase the scaling factor for the rectangle by `0.1`      |
| `-`/`_` (key)              | Decrease the scaling factor for the rectangle by `0.1`. This number should not go below `0.1`                                                           |
| `D` (key)                  | Print the current `Model` to the terminal (useful for testing)                                                                                     |
| Click-drag-release (mouse) | Used to draw various shapes.                            |
| Click (mouse)              | Used to draw various shapes.                             | 


---

## Task 1: Helper Functions

The easiest way to solve a large problem is often to break it apart
into smaller, easier problems. Programming is the same. In this task
you will write some helper functions that will make future tasks
easier. You can test your implementations by running `cabal v2-test`.

The functions you need to write for this task are:

* `toolToLabel` in `src/View.hs`. This function should return
  instructions for the user on how to use each `Tool`, according to
  the following table:

| Tool               | Label                                                                   |
|--------------------|-------------------------------------------------------------------------|
| `LineTool`         | `"Line: click-drag-release"`                                            |
| `PolygonTool`      | `"Polygon: click 3 or more times then spacebar"`                        |
| `CircleTool`       | `"Circle: click-drag-release between centre and circumference"`         |
| `TriangleTool`     | `"Triangle: click-drag release for first 2 corners"`                    |
| `RectangleTool`    | `"Rectangle: +/- to increase/decrease scaling factor; click-drag release for first 2 corners"` |
| `CapTool`          | `"Cap: click-drag-release for circle, then click for cap level"`         |


**Note:** At the time this assignment is released, the course will have only
briefly covered lists. You do not need to manipulate lists to write
`toolToLabel`; you can use a blank pattern (`_`) to ignore them.

* `nextColour` in `src/Controller.hs`. This function should return the
  next colour in our set of `ColourName`s:

| Argument | Result   |
|----------|----------|
| `Black`  | `Red`    |
| `Red`    | `Orange` |
| `Orange` | `Yellow` |
| `Yellow` | `Green`  |
| `Green`  | `Blue`   |
| `Blue`   | `Purple` |
| `Purple` | `White`  |
| `White`  | `Black`  |

* `nextTool` in `src/Controller.hs`. This function implements
  tool-switching, but should not change `Tool` if the user is halfway
  through an operation:

  - If the tool is not holding a point (that is, a non-`PolygonTool`
    tool holding `Nothing` (in all applicable fields) or a `PolygonTool` holding the empty list
    `[]`), select the next tool in the following sequence: `Line` ->
    `Polygon` -> `Circle`  -> `Triangle` -> `Rectangle`-> `Cap` -> `Line`.
    Note that the `Double` argument of `Rectangle` should be initialised at `1.0`.

  - If there is a `Point` stored in the given tool (because it is
    holding a `Just` value or the list in `PolygonTool` is non-empty),
    return the argument unchanged.

  - If this is unclear, study the `nextToolTests` in
    `test/ShapesTest.hs`.

**Note:** At the time this assignment is released, the course will have
only briefly covered lists. You can write the `PolygonTool` case for
`nextTool` without using list recursion. Use `[]` to match an empty
list. In a subsequent case, give the entire list a name like `points`
to match any nonempty list (or find a way to use the `_` pattern!).

---

**Part B begins...**

---

## Task 2: Rendering Shapes (COMP1100: 35 marks, COMP1130: 30 marks)

In `src/View.hs`, `modelToPicture` converts your `Model` type into a
CodeWorld `Picture`, so that it can be displayed on the screen. It
currently does not work, because `colourShapesToPicture` is
`undefined`. In this task you will fill in that missing piece,
building up a function to convert the `[ColourShape]` from your
`Model` into a `Picture`. You can test these functions individually by
using `cabal v2-repl comp1100-assignment1`, using `drawingOf` to show
small pictures on the screen. You can also test everything as a whole
by launching the program with `cabal v2-run shapes` and pressing the `S`
key to show the sample image. The functions you need to write for
this task are all in `src/View.hs`:

* `colourNameToColour`: This function turns your `ColourName` type
  from the _model_ into a CodeWorld `Colour`. You should check [the
  CodeWorld
  documentation](https://hackage.haskell.org/package/codeworld-api-0.6.0/docs/CodeWorld.html#g:3) for information on colours.

* `shapeToPicture`: This function turns your `Shape` type into a
  CodeWorld `Picture`. You will need to consider the constructors for
  `Shape` individually, and work out the best way to turn each one
  into a `Picture`. Here are some hints to help you along:

  - CodeWorld has no function to draw a single line segment. It does
    have a function to draw a line made of multiple segments -
    `polyline`. It also has no function _for_ triangles, caps, or the rectangles
    of this assignment, but it does have functions that can draw these shapes.

  - Polygons, circles, triangles, rectangles, and caps should be drawn as
    solid (filled) `Picture`s.

  - Many of CodeWorld's functions draw individual shapes centred on
    the origin - `(0, 0)`. You will need to figure out how to slide
    (translate) the generated `Picture` so it shows up where it is
    supposed to go. Drawing diagrams will help. The `abs` function
    might also help - it computes the absolute value of its argument
    (i.e., `abs x == x` if `x > 0`, and `abs x == - x` otherwise).

  - (Isosceles) triangles should be defined by dragging from the apex to one
    of the vertices on the base. The base should run parallel to the x axis.
    Note that this means that triangles will look
    different depending on whether the user drags upwards or downwards. 

  - Rectangles are also defined by the user defining a first edge.
    The second vertex (where the pointer was released) will then be the start of the
    second edge, stretching out *clockwise* from the user-defined edge, and
    with length equal to the scaling factor of the rectangle multiplied by the length of
    the defined edge. Note that because of the clockwise requirement, the direction of
    the user's drag will matter, and that the rectangle will not necessarily run parallel
    to the x and y axes.

  - Caps are *circular segments* (not to be confused with sectors) defined by defining
    a circle by click-drag-release the same way as above, then clicking a point which determines
    the y coordinate below which the circle must be cut off (the x coordinate of this 
    click is not used). If the cutoff point is below the circle,
    the whole circle should remain intact, or "full". If the cutoff point is above,
    the whole circle should be clipped, and so the resultant (degenerate) segment will be "empty".
    Note that this task may require you to look through
    the CodeWorld documentation.

* `colourShapeToPicture`: This function should render the `Shape` and
  colour it using the Colour that corresponds to the given
  `ColourName`.

* `colourShapesToPicture`: This function should turn every
  `ColourShape` in a list into a single `Picture`. You will need
  to recurse over the input list. If you have not yet completed Lab 5,
  you may want to work on other parts of the assignment and come back
  to this.

* Here is the sample image for you to test your work against:
![sample image](Sample.png){:.w300px}

---

## Task 3: Handling Events (COMP1100: 30 marks, COMP1130: 25 marks)

It is now time to tackle `handleEvent` in
`src/Controller.hs`. CodeWorld calls this function whenever something
interesting happens (like a key press, a pointer press, or a
pointer release). This function is called with two arguments:

* The `Event` that just happened, and
* The current `Model` at the time the `Event` happened.

`handleEvent` then returns a new `Model` for the program to use moving
forward.

(Aside: [Elm](https://elm-lang.org) is a functional programming
language that uses a similar pattern to build front-end web
applications that are compiled to JavaScript.)

Let's trace a simple interaction. If the user wants to draw a *red
line* by clicking on the screen at coordinates $$(1, 1)$$ and
releasing the mouse at coordinates $$(2, 2)$$. starting at a blank
canvas, the state would transition as follows, starting with the
initial model:

1. `Model [] (LineTool Nothing) Black`

2. The user presses "C" to change the colour from black to red:

   `Model [] (LineTool Nothing) Red`

4. The user presses the mouse button at $$(1, 1)$$ changing the state to

   `Model [] (LineTool (Just (1.0,1.0))) Red`

5. The user releases the mouse button at $$(2, 2)$$ changing the state to

   `Model [(Line (1.0,1.0) (2.0,2.0),Red)] (LineTool Nothing) Red`

{:.msg-info}
Note that the `Tool` and the `ColourName` do not reset to the default values
after a shape has been drawn. However, the `Maybe Point` inside the tool
should revert to `Nothing`.


### Task 3.1: Handling Mouse Input

CodeWorld provides a few different event constructors for mouse input,
but the ones we're interested in here are `PointerPress` for when the user
clicks, and `PointerRelease` for when the user releases the mouse
button.

When a `PointerPress` event arrives, you will need to store it in the
current `Tool`. For everything except `PolygonTool`, you will store it
in the `Maybe Point` argument. For `PolygonTool`, you will add it to
the list of vertices. For `CapTool` you will have to consider whether
the press is intended to draw the defining circle, or give the y coordinate
to cut the circle off at.

When a `PointerRelease` event arrives, we can ignore it for
`PolygonTool`, as we will be finishing polygons using
the spacebar in Task 3.2. For almost everything else, a `PointerRelease` will
mean the end of a click-drag-release action, so you should construct the appropriate
shape and add it to the `[Shape]` in the `Model`. You should also
remove the starting point from the current `Tool`, so that future
shapes draw properly too. For `CapTool`, you will have to consider whether the
user is finishing defining the circle, or releasing after clicking for the y coordinate
cut-off.

Once you have finished this task for normal input, you may also want to consider
how your program will behave on unexpected input. For example, what should your program
do if it receives two consecutive `PointerPress` inputs without a `PointerRelease` between them? 

### Task 3.2: Handling Key Presses

To handle keyboard input, CodeWorld provides a `KeyPress` event. This
is already present in the assignment skeleton, because we have
implemented some keyboard functionality already. In the "Overview of
the Program" section, we listed the full set of keyboard commands that
your program will respond to. You need to implement the missing
functionality for these keys:

| Key                  | Effect                                                           |
|----------------------|------------------------------------------------------------------|
| `C`                  | Change colour (of shape to draw)                                 |
| `T`                  | Change tool (type of shape to draw)                              |
| `Backspace`/`Delete` | Remove the last added shape                                      |
| `Spacebar`           | Finish drawing a polygon, adding it to the canvas.               |
| `+`/`=`              | Increase the scaling factor for the rectangle by `0.1`           |
| `-`/`_` (key)        | Decrease the scaling factor for the rectangle by `0.1`. This number should not go below `0.1`                                                          |

If you have made it this far, you should not need to write a lot of
code to implement these. A few hints:

* Think back to Task 1.
* `Backspace`/`Delete` with no shapes drawn should not crash the program.
* Nor should any other unexpected input. Try to test some ``unexpected'' cases.


---


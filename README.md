# The Door Across

A short, original 2D visual novel made in Godot 4.6.3. Alone in a laundromat during rain, you notice a shadow reaching toward the light. Decide whether to investigate, make room, or leave.

A single route takes roughly 2–4 minutes at an ordinary reading pace. There is no timer. The story has three endings: **A Place to Stand**, **The Second Chair**, and **Nothing Followed**. Choices determine the route; there is no random ending or hidden score. This is standalone fictional supernatural suspense, not a story drawn from the player's life. No graphic violence, jump-scare flashes or required audio.

## Controls

- **1 / 2** or **left-click** a choice to continue.
- **Tab + Enter** navigates and activates standard buttons.
- **R** or the Restart button returns to the beginning at any time.
- **M** or the Motion button freezes/resumes the gentle backdrop animation.
- At an ending, **1** or Begin Again starts a clean playthrough.

The game remembers only the current route in memory. It does not save files, access the network, collect data or inspect anything outside the game. Restart clears the route. Motion preference persists only until the program closes. Desktop keyboard/mouse is the supported input; mobile touch is not certified.

## Run or edit

Open `project.godot` in Godot **4.6.3** and press F5. `main.tscn` loads `game.gd`, which contains the story graph, native button UI, input and tests. `backdrop.gd` draws the original procedural laundromat. No external art, audio, copied narrative or game code is imported. The UI uses Godot's fallback font.

For a Web export, serve the extracted Web folder using:

```
python -m http.server 8000 --bind 127.0.0.1
```

Then open `http://127.0.0.1:8000`. Opening the HTML via `file://` is not supported. Export availability does not imply a browser/native-platform runtime playtest; check the verification report supplied with the build.

## Automated verification

```
godot --headless --path . -- --test
```

The release-safe smoke checks exit nonzero on failure. Marker: `THE DOOR ACROSS TEST PASSED`. Checks route links, every complete branching route through actual viewport keyboard input, all three endings, native button mouse progression, clean ending/button/keyboard restart, absent choice rejection, reduced motion, and text minimum-height fitting within its dialogue region. Headless layout/input validation is not a rendered screenshot review or human playthrough.

## Rights

The code, story and procedural artwork are original to this prototype. No new open-source license is granted for the original material. Godot and its included components retain their respective licenses; playable packages should include `GODOT_NOTICES.txt`. This prototype makes no game-jam participation claim.

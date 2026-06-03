---
category: LiveView experiment
name: Sphxace Invaders
description: A server-driven arcade game exploring how far LiveView could go.
cover: /images/screen-shot-2021-05-01-at-8.47.40-pm.png
gallery: [{"src":"/images/screen-shot-2021-05-01-at-8.48.27-pm.png","alt":"Space Invaders game beside browser developer tools showing ship positions in the DOM","caption":"The game alongside its DOM updates. Open the image to inspect the ship positions at full size.","width":1190,"height":520}]
position: 5
---
## A game as an experiment

I recreated Space Invaders in Phoenix LiveView to explore its limits for a fast-changing, interactive interface. LiveView was still new at the time, and a game offered a different test from a typical web app.

## A 50-millisecond game loop

Every 50 milliseconds, the game updated enemy ships, the player's ship, and projectiles, then detected and displayed collisions.

I wrote the game logic in LiveView, with no custom JavaScript running on the client. LiveView handled the browser updates over its connection to the server.

## What it demonstrates

The experiment put game state and collision detection on the server while the browser displayed the changes.

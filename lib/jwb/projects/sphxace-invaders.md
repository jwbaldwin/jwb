---
category: game
title: Sphxace Invaders
description: A Space Invaders-type game implemented using Phoenix LiveView to
  showcase the performance of the Phoenix Channels API over a network
cover: /img/screen-shot-2021-05-01-at-8.47.40-pm.png
gallery:
  - /img/screen-shot-2021-05-01-at-8.48.27-pm.png
position: 3
---
### What is it?

This was a recreation of the famous Space Invaders game, but using only Phoenix LiveView, which was very new at the time. The entirety of this game is written in Phoenix Liveview with **0 lines of JavaScript**!

The game "tick" speed is 50ms, which means every 50ms Phoenix LiveView is updating all of the folowing: enemy ship posisitions, user ship position, projectile position, detectingand displaying colision with projectiles. No code (written by me) runs on the client.

This was written as a test to see what the boundaries of Phoenix LiveView/Websockets might be. I have not found it yet :)

Here are some screen shots of the updates happening in the dev panel (insane!):

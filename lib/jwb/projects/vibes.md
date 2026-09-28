---
category: Ambient music
name: Vibes
description: Music and ambient scenes for focus, relaxation, and everything in between.
cover: /images/projects/vibes.png
gallery: [{"src":"/images/vibes-player.jpg","alt":"Vibes playing spring lofi music over a sunlit window scene with playback and volume controls","caption":"The spring station, with music controls kept at the edge of the scene.","width":1440,"height":900},{"src":"/images/vibes-stations.jpg","alt":"Vibes station picker showing seasonal and mood-based stations including cozy, locked in, and rainy day","caption":"Stations organized by season and mood, with keyboard shortcuts and listener counts.","width":1440,"height":900},{"src":"/images/vibes-timer.jpg","alt":"A snowy cabin scene in Vibes with the Pomodoro timer open in the upper-right corner","caption":"The winter station with the built-in work and break timer.","width":1440,"height":900},{"src":"/images/vibes-og.jpg","alt":"Ivory Vibes lettering in front of a listener surrounded by autumn leaves, snow, coffee, and a pink sunset","caption":"The Vibes artwork: good vibes for every occasion.","width":1200,"height":630}]
position: 1
---
[Vibes](https://vibes.jwbaldwin.com) is a little ambient cafe in your browser. Pick a season or a mood, put on some music, and leave it running. It pairs YouTube videos with a retro interface, keyboard controls, and a built-in Pomodoro timer.

## Keeping playback steady

I built it with Elixir, Phoenix LiveView, PostgreSQL, and Tailwind CSS. Station edits reach connected listeners through PubSub, so I can reorder a station without restarting the video someone is watching.

The YouTube player uses a small JavaScript hook. Play and mute happen directly in the browser's click or keyboard event, rather than waiting for a server round trip that could lose the user gesture browsers require for playback.

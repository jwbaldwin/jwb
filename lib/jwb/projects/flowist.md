---
category: Remote teamwork
name: Flowist
description: Shared progress, check-ins, and announcements for distributed teams.
cover: /images/projects/flowist.png
gallery: [{"src":"/images/3.png","alt":"Flowist team announcement with a Mark as seen action","caption":"Team announcements made shared updates visible alongside a check-out action.","width":1920,"height":1080},{"src":"/images/4.png","alt":"Flowist dashboard with community switching and a list of teams","caption":"The interface grouped teams within communities, with navigation between them.","width":1920,"height":1080}]
position: 4
---
## Keeping a team informed

Flowist was a progress tracker for distributed teams. It gave teammates a place to share what they were working on and stay aware of each other's activity.

The interface brought together check-ins, team announcements, and navigation across multiple communities. Teams sat within communities, and announcements included a "Mark as seen" action so reading an update was an explicit step.

## Replacing the frontend and its state management

The API used Elixir and Phoenix. I initially built the frontend with React and Redux, then moved both the interface and its state management to Vue and Vuex. Tailwind CSS handled styling.

Vue offered a simpler development experience for me, with a more guided set of choices. That preference shaped the frontend migration.

## In use

The app reached 10 users on the free tier and 2 users on the paid tier. Flowist is no longer actively developed.

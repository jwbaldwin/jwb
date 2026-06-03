---
category: Retail analytics
name: Kept
description: Turning Shopify data into customer insights and practical next steps for retailers.
cover: /images/kept-logo.png
gallery: [{"src":"/images/kept-home.jpg","alt":"Kept briefing with customer spending, product trends, and suggested next steps","caption":"The briefing pairs each insight with a next step, such as rewarding customers or restocking a popular product.","width":1600,"height":900}]
position: 1
---
## The product

Kept helped retailers find valuable customers, spot product trends, and identify opportunities to bring customers back. It connected to Shopify and turned store activity into reports and suggested actions.

The briefing put the insight and the next step side by side: who was spending, what was selling, and how a retailer could respond.

## Keeping reports fast

The core engineering work was synchronizing Shopify data. We ran a full sync when a store joined, then delta syncs every few hours or on request.

Each morning, scheduled jobs analyzed the data and stored the reports. Customers could open a prepared report instead of triggering expensive queries while they waited. The reports reflected the sync and processing schedule rather than live calculations.

## Built with

Elixir, Phoenix, and Shopify integration. The interface started in Phoenix LiveView and later moved to Next.js and Tailwind CSS.

Kept is no longer actively developed.

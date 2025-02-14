---
category: SaaS App
name: Kept
description: A customer engagement and insight platform for retailers
cover: /images/kept-logo.png
gallery: ["/images/kept-home.jpg"]
position: 1
---
[https://gokept.com](https://gokept.com)

### What is it?

An app for retailers that provides insights and engagement oppurtunities to customers. Integrates with Shopify to analyze and detect valuable customers, popular items, trends, and ways to engage in a quick and impactful way to drive repeat customers and increase brand loyalty.

### Details

The nitty gritty behind Kept was the sync between Shopify data and the app. We would do a full sync when they onboarded
and then we would do a delta sync every few hours or upon request. Then each morning we'd fire off a bunch of cron jobs that would analyze then data and build reports. These reports were then stored so that when a customer came in they could see the reports
instantly rather than putting out database under heavy load.

### Tech Stack

- Elixir/Phoenix backend
- Phoenix LiveView
- Later migrated to Nextjs/Tailwindcss frontend
- Shopify integration


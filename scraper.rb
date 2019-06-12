#!/usr/bin/env ruby
Bundler.require

ATDISPlanningAlertsFeed.save(
  "https://datracker.muswellbrook.nsw.gov.au/atdis/1.0",
  "Sydney"
)

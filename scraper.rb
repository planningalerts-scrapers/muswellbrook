#!/usr/bin/env ruby
Bundler.require

ATDISPlanningAlertsFeed.save(
  "http://datracker.muswellbrook.nsw.gov.au/atdis/1.0",
  "Sydney"
)

#!/usr/bin/env ruby
Bundler.require

url = "http://datracker.muswellbrook.nsw.gov.au/atdis/1.0"

ATDISPlanningAlertsFeed.save(url, "Sydney")

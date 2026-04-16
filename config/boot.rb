ENV["RAILS_MASTER_KEY"] = "0eac65ec0eddd7dd6908ceb72f2cbc5e"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

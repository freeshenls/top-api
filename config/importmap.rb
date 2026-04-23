# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/dialog", to: "@stimulus-components--dialog.js" # @1.0.1
pin "@stimulus-components/password-visibility", to: "@stimulus-components--password-visibility.js" # @3.0.0
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "stimulus-use" # @0.52.3
pin "@stimulus-components/popover", to: "@stimulus-components--popover.js" # @7.0.0
pin "@stimulus-components/dropdown", to: "@stimulus-components--dropdown.js" # @3.0.0
pin "@stimulus-components/carousel", to: "@stimulus-components--carousel.js" # @6.0.0
pin "swiper/bundle", to: "swiper--bundle.js" # @11.2.10
pin "@stimulus-components/reveal", to: "@stimulus-components--reveal.js" # @5.0.0

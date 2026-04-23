import { Application } from "@hotwired/stimulus"
import Dialog from "@stimulus-components/dialog"
import PasswordVisibility from '@stimulus-components/password-visibility'
import Popover from '@stimulus-components/popover'
import Notification from '@stimulus-components/notification'
import Dropdown from '@stimulus-components/dropdown'
import Carousel from '@stimulus-components/carousel'

import Reveal from '@stimulus-components/reveal'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("dialog", Dialog)
application.register('password-visibility', PasswordVisibility)
application.register('popover', Popover)
application.register('notification', Notification)
application.register('dropdown', Dropdown)
application.register('carousel', Carousel)
application.register('reveal', Reveal)

export { application }

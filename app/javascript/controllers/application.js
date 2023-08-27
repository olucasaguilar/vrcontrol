// yarn add @rails/ujs
import Rails from "@rails/ujs";
Rails.start();

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

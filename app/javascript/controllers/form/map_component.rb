# frozen_string_literal: true

class Form::MapComponent < ViewComponent::Base
  def initialize(form:, height: "h-48")
    @form = form
    @height = height
  end
end

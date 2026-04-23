# frozen_string_literal: true

class Auth::CardComponent < ViewComponent::Base
  def initialize(resource:, active_tab: :login)
    @resource = resource
    @active_tab = active_tab
  end

  def active_index
    @active_tab == :register ? 1 : 0
  end
end

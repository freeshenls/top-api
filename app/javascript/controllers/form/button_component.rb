# app/components/form/button_component.rb
class Form::ButtonComponent < ViewComponent::Base
  def initialize(form:, text:, shadow: true, class_names: nil)
    @form = form
    @text = text
    @shadow = shadow
    @class_names = class_names
  end

  def button_classes
    [
      "w-full bg-gradient-to-r from-[#0EA5E9] to-[#0369A1]",
      "hover:from-[#0284C7] hover:to-[#075985]",
      "text-white py-4 rounded-2xl font-bold text-base cursor-pointer",
      "active:scale-[0.98] transition-all duration-300",
      (@shadow ? "shadow-lg shadow-sky-700/30" : ""),
      @class_names
    ].join(" ")
  end
end

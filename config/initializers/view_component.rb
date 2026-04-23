# config/initializers/view_component.rb

ActiveSupport.on_load(:view_component) do
  include Heroicons::Helper
  # 1. 包含 Devise 辅助方法 (current_user, resource 等)
  include Devise::Controllers::Helpers

  # 2. 包含 Rails 路由辅助方法 (root_path, new_user_session_path 等)
  include Rails.application.routes.url_helpers

  # 3. 如果你有自定义的 ApplicationHelper，也可以包含进来
  include ApplicationHelper

  # 4. 包含 RuCaptcha 验证码辅助方法
  include RuCaptcha::ViewHelpers if defined?(RuCaptcha)
end

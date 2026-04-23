class AddIndexesToCoreTables < ActiveRecord::Migration[8.1]
  def change
    # sys_user
    add_index :sys_user, :is_vip if column_exists?(:sys_user, :is_vip)
    add_index :sys_user, :is_admin if column_exists?(:sys_user, :is_admin)

    # category
    add_index :category, :position if column_exists?(:category, :position)
    add_index :category, :parent_id if column_exists?(:category, :parent_id)
    add_index :category, :active if column_exists?(:category, :active)

    # site
    add_index :site, :position if column_exists?(:site, :position)
    add_index :site, :active if column_exists?(:site, :active)

    # post
    add_index :post, :published_at if column_exists?(:post, :published_at)
    add_index :post, :active if column_exists?(:post, :active)

    # activity
    add_index :activity, :event_date if column_exists?(:activity, :event_date)
    add_index :activity, :active if column_exists?(:activity, :active)
    add_index :activity, :status if column_exists?(:activity, :status)

    # carousel_item
    add_index :carousel_item, :position if column_exists?(:carousel_item, :position)
    add_index :carousel_item, :active if column_exists?(:carousel_item, :active)
  end
end

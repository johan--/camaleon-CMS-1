class PostTableIntoUtf8 < ActiveRecord::Migration
  def change
    create_table "users" do |t|
      t.string   "username", index: true
      t.string   "role", default: "client", index: true
      t.string   "email", index: true
      t.string   "slug"
      t.string   "password_digest"
      t.string   "auth_token"
      t.string   "password_reset_token"
      t.integer  "parent_id"
      t.datetime "password_reset_sent_at"
      t.datetime "last_login_at"

      # t.integer  "site_id",   default: -1
      t.timestamps
      t.belongs_to :site, index: true, default: -1, foreign_key: true
    end

    create_table "term_taxonomy" do |t|
      t.string   "taxonomy", index: true
      t.text     "description", limit: 1073741823
      t.integer  "parent_id", index: true
      t.integer  "count"
      t.string   "name"
      t.string   "slug", index: true
      t.integer  "term_group"
      t.integer  "term_order", index: true
      t.string   "status"

      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table "posts" do |t|
      t.string   "title"
      t.string   "slug", index: true
      t.text     "content",          limit: 1073741823
      t.text     "content_filtered", limit: 1073741823
      t.string   "status", default: "published", index: true
      t.integer  "comment_count", default: 0
      t.datetime "published_at"
      t.integer  "post_parent", index: true
      t.string   "visibility", default: "public"
      t.text     "visibility_value"
      t.string   "post_class", default: "Post", index: true

      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table "term_relationships" do |t|
      t.integer "objectid", index: true
      t.integer "term_order", index: true
      t.belongs_to :term_taxonomy, index: true, foreign_key: true
    end

    create_table "user_relationships" do |t|
      t.integer "term_order"
      t.integer "active", default: 1

      t.belongs_to :term_taxonomy, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table "comments" do |t|
      t.string   "author"
      t.string   "author_email"
      t.string   "author_url"
      t.string   "author_IP"
      t.text     "content"
      t.string   "approved", default: "pending", index: true
      t.string   "agent"
      t.string   "typee"
      t.integer  "comment_parent", index: true
      t.belongs_to :post, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end

    create_table "custom_fields" do |t|
      t.string  "object_class", index: true
      t.string  "name"
      t.string  "slug", index: true
      t.integer  "objectid", index: true
      t.integer "parent_id", index: true
      t.integer "field_order"
      t.integer "count", default: 0
      t.boolean "is_repeat", default: false
      t.text    "description"
      t.string  "status"
    end

    create_table "custom_fields_relationships" do |t|
      t.integer "objectid", index: true
      t.integer "custom_field_id", index: true
      t.integer "term_order"
      t.string  "object_class", index: true
      t.text    "value", limit: 1073741823
      t.string  "custom_field_slug", index: true
    end

    create_table "metas" do |t|
      t.string  "key", index: true
      t.text    "value", limit: 1073741823
      t.integer "objectid", index: true
      t.string  "object_class", index: true
    end

    if ActiveRecord::Base.connection.adapter_name.downcase.include?("mysql")
      ActiveRecord::Base.connection.execute "ALTER TABLE posts CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;" rescue nil
      ActiveRecord::Base.connection.execute "ALTER TABLE custom_fields_relationships CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;" rescue nil
    end
  end
end

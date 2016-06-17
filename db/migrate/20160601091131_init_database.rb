class InitDatabase < ActiveRecord::Migration
  def change
    execute <<-SQL
    CREATE TYPE ticket_status AS ENUM ('fresh', 'viewed', 'paid', 'completed', 'closed')
    SQL

    create_table :accounts do |t|
      t.string :login
      t.string :password_digest
      t.boolean :is_tmp_password
      t.timestamp :last_visit
      t.references :profile, polymorphic: true, index: true
      t.timestamps null: false
    end
    add_index :accounts, :login, :unique => true

    create_table :customers do |t|
      t.string :company_name
      t.string :firstname
      t.string :secondname
      t.string :lastname
      t.string :phone
      t.string :site_url
      t.text :description
      t.timestamps null: false
    end

    create_table :admins do |t|
      t.string :firstname
      t.string :secondname
      t.string :lastname
      t.boolean :is_super
      t.timestamps null: false
    end

    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.belongs_to :customer, index: true
      t.belongs_to :admin, index: true
      t.column :status, :ticket_status, index: true, default: :fresh
      t.references :relationship, index: true
      t.timestamps null: false
    end

    create_table :comments do |t|
      t.string :text, limit: 140
      t.belongs_to :account, index: true
      t.belongs_to :ticket, index: true
      t.timestamps null: false
    end
  end
end

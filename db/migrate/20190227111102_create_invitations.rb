class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :group_id
      t.text :invitation_link
      t.boolean :is_approved, :default => false

      t.timestamps
    end
  end
end

      
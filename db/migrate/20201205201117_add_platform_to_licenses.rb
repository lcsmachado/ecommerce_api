class AddPlatformToLicenses < ActiveRecord::Migration[6.0]
  def change
    add_column :licenses, :platform, :integer
  end
end

class CreateRestfulSyncApiTargets < ActiveRecord::Migration
  def change
    create_table :restful_sync_api_targets do |t|
      t.string :end_point

      t.timestamps
    end
  end
end

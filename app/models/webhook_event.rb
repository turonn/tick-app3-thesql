# == Schema Information
#
# Table name: webhook_events
#
#  id                :bigint           not null, primary key
#  data              :json
#  processing_errors :text
#  source            :string
#  state             :integer          default("pending")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#
# Indexes
#
#  index_webhook_events_on_external_id             (external_id)
#  index_webhook_events_on_source                  (source)
#  index_webhook_events_on_source_and_external_id  (source,external_id)
#
class WebhookEvent < ApplicationRecord
  enum state: { pending: 0, processing: 1, processed: 2, failed: 3 }
end

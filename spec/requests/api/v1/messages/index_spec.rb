require 'rails_helper'

describe 'GET /api/v1/conversations/:conversation_id/messages', type: :request do
  let(:user)   { create(:user) }
  let(:user2)  { create(:user) }
  let(:topic)  { create(:topic) }
  let!(:conversation1) { create(:conversation, topic_id: topic.id) }
  let!(:conversations_user1) { create(:conversations_user, user:, conversation: conversation1) }
  let!(:conversations_user2) { create(:conversations_user, user: user2, conversation: conversation1) }

  context 'when the request is valid' do
    let!(:messages) do
      create_list(:message, 25, conversation: conversation1, user_id: user.id)
    end
    subject do
      get "/api/v1/conversations/#{conversation1.id}/messages", headers: auth_headers, as: :json
    end

    it 'returns the correct messages in descending order' do
      subject
      expect(json).not_to be_empty
      expect(json['messages'].pluck('id'))
        .to match_array(conversation1.messages.last(10).pluck(:id))
    end

    it 'returns a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'returns the correct amount of messages per page' do
      subject
      expect(json['messages'].size).to eq(Message::MAX_MESSAGES)
    end
  end
end

module Api
  module V1
    class TargetsController < Api::V1::ApiController
      def create
        authorize Target
        @target = Target.create!(target_params)
      end

      private

      def target_params
        params.require(:target).permit(:title, :radius, :lat, :lon, :topic_id, :user_id)
      end
    end
  end
end

class Api::V1::NotificationsController < ApplicationController
  ## GET
  # @api_description
  # @action=notifications
  # Returns all of the notifications given a certain user id.
  # Up to 30 notifications are returned with any one query, and they are sorted in
  # descending order according to the most recent ones.
  # If the user has specified their location, returns the most recent 30 locations near the user according
  # to their search radius.
  # Params: id
  # @end_description
  def notifications
    user = User.find_by_id(params[:id])

    if !user.nil?
      results =
      if !user.location.blank?
        Notification.near(user.location, user.search_radius).order(created_at: :desc).last(30)
      else
        Notification.order(created_at: :desc).last(30)
      end

      render json: results, status: 200
    else
      render json: { errors: "user does not exist" }, status: 422
    end
  end
end

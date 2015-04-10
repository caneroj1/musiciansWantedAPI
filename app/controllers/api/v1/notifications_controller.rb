class Api::V1::NotificationsController < ApplicationController
  ## GET
  # this gets all of the notifications given a certain user id.
  # if there are no filters, we simply get the most recent 30 notifications.
  # if there is a location, we get the most recent 30 locations near the user according
  # to their search radius.
  # other search filters will be incorporated as needed.
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

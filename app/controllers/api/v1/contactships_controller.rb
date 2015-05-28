class Api::V1::ContactshipsController < ApplicationController
  ## GET
  # @api_description
  # @action=contacts
  # This will return all of the contacts for the specified user.
  # Params: user_id
  # @end_description
  def contacts
    user = User.find_by_id(params[:user_id])
    if !user.nil?
      render json: user.contacts, status: 200
    else
      render json: { errors: "That user does not exist" }, status: 422
    end
  end

  ## GET
  # @api_description
  # @action=knows
  # Returns true or false depending on if the user corresponding to :user_id
  # has a contact by the with id = contact_id.
  # Params: user_id, contact_id
  # @end_description
  def knows
    render json: { knows: User.find_by_id(params[:user_id]).try(:contactships).exists?(contact_id: params[:contact_id]) }
  end

  ## POST
  # @api_description
  # @action=create
  # This will create the specified contactship. The API adds a new contactship
  # between the user and desired contact only if it doesn't already exist.
  # Params: user_id, contact_id
  # @end_description
  def create
    user = User.find_by_id(params[:user_id])
    if !user.nil?
      new_contactship = user.contactships.new(contact_id: params[:contact_id])
      if new_contactship.save
        render json: new_contactship, status: 201
      else
        render json: { errors: new_contactship.errors }, status: 422
      end
    else
      render json: { errors: "user does not exist" }, status: 422
    end
  end

  ## DELETE
  # @api_description
  # This will delete the specified contactship from a user. It finds the user
  # by the user_id and then it finds the contact by the contact_id
  # Params: user_id, contact_id
  # @action=destroy
  # @end_description
  def destroy
    user = User.find_by_id(params[:user_id])

    if !user.nil?
      contactship = user.contactships.find_by_contact_id(params[:contact_id])
      if !contactship.nil?
        contactship.delete
        render json: { info: "contact deletion successful" }, status: 200
      else
        render json: { errors: "contact does not exist" }, status: 422
      end
    else
      render json: { errors: "user does not exist" }, status: 422
    end
  end
end

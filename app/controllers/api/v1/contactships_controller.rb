class Api::V1::ContactshipsController < ApplicationController
  ## GET
  # this will return all of the contacts for the specified user.
  def contacts
    user = User.find_by_id(params[:user_id])
    if !user.nil?
      render json: user.contacts, status: 200
    else
      render json: { errors: "That user does not exist" }, status: 422
    end
  end

  ## POST
  # this will create the specified contactship. we add a new contactship
  # between the user and desired contact if it doesn't already exist
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
  # this will delete the specified contactship from a user. it finds the user
  # by the user_id and then it finds the contact by the contact_id
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

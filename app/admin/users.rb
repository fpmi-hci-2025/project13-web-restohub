# frozen_string_literal: true

ActiveAdmin.register User do
  menu label: proc { "<i class='fa-solid fa-person'></i> Users".html_safe }
  actions :all
  permit_params :first_name, :last_name, :nickname, :email, :phone, :status,
                :password, :password_confirmation, role_ids: []

  filter :email
  filter :first_name
  filter :last_name
  filter :nickname
  filter :phone
  filter :status
  filter :roles

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :nickname
    column :phone
    column :status
    column(:roles) { |user| user.roles.pluck(:name).join(', ') }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :nickname
      row :phone
      row :status
      row(:roles) { |user| user.roles.pluck(:name).join(', ') }
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :nickname
      f.input :email
      f.input :phone
      f.input :status
      f.input :roles, as: :check_boxes
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      super
    end
  end
end

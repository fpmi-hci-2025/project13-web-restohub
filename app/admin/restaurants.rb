# frozen_string_literal: true

ActiveAdmin.register Restaurant do
  menu priority: 2, label: proc { I18n.t('active_admin.restaurants.menu') }

  permit_params :name,
                :cuisine_type,
                :address,
                :rating,
                :partnership_status,
                :delivery_time_min,
                :delivery_time_max,
                :free_delivery,
                :delivery_price,
                :photo,
                categories: []

  scope :all, default: true
  scope(I18n.t('active_admin.restaurants.scopes.active'))     { |scope| scope.where(partnership_status: :active) }
  scope(I18n.t('active_admin.restaurants.scopes.paused'))     { |scope| scope.where(partnership_status: :paused) }
  scope(I18n.t('active_admin.restaurants.scopes.terminated')) { |scope| scope.where(partnership_status: :terminated) }

  filter :name
  filter :address
  filter :rating
  filter :partnership_status, as: :select, collection: Restaurant.partnership_statuses.keys
  filter :free_delivery
  filter :delivery_price
  filter :created_at
  filter :categories, as: :check_boxes, collection: Restaurant::CATEGORIES

  index do
    selectable_column
    id_column

    column :photo do |restaurant|
      if restaurant.photo.attached?
        image_tag url_for(restaurant.photo.variant(:thumb)), class: 'rounded'
      end
    end

    column :name

    column :cuisine_type do |restaurant|
      restaurant.ui_categories.join(', ').presence || 'Empty'
    end

    column :address
    column :rating
    column :partnership_status
    column :free_delivery
    column :delivery_price
    column :delivery_time_min
    column :delivery_time_max
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :name

      row :cuisine_type do |restaurant|
        restaurant.ui_categories.join(', ').presence || 'Empty'
      end

      row :address
      row :rating
      row :partnership_status
      row :free_delivery
      row :delivery_price
      row :delivery_time_min
      row :delivery_time_max
      row :created_at
      row :updated_at

      row :photo do |restaurant|
        if restaurant.photo.attached?
          image_tag url_for(restaurant.photo.variant(:card))
        end
      end
    end

    panel I18n.t('active_admin.restaurants.related_dishes') do
      table_for restaurant.dishes do
        column :id
        column :name
        column :category
        column :price
        column :is_available
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs I18n.t('active_admin.restaurants.form.basic_info') do
      f.input :name

      f.input :categories,
              as: :check_boxes,
              collection: Restaurant::CATEGORIES,
              input_html: { multiple: true }

      f.input :address
      f.input :rating, hint: I18n.t('active_admin.restaurants.hints.rating')
      f.input :partnership_status,
              as: :select,
              collection: Restaurant.partnership_statuses.keys,
              include_blank: false
    end

    f.inputs I18n.t('active_admin.restaurants.form.delivery') do
      f.input :delivery_time_min
      f.input :delivery_time_max
      f.input :free_delivery
      f.input :delivery_price
    end

    f.inputs I18n.t('active_admin.restaurants.form.photo') do
      if f.object.photo.attached?
        div do
          image_tag url_for(f.object.photo.variant(resize_to_limit: [300, 200])),
                    class: 'mb-2 rounded'
        end
      end

      f.input :photo, as: :file, hint: I18n.t('active_admin.restaurants.hints.photo')
    end

    f.actions
  end
end

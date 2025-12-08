# frozen_string_literal: true

ActiveAdmin.register Dish do
  menu priority: 3, label: proc { I18n.t('active_admin.dishes.menu') }

  permit_params :restaurant_id,
                :name,
                :category,
                :price,
                :is_available,
                :photo

  filter :restaurant
  filter :name
  filter :category
  filter :price
  filter :is_available
  filter :created_at

  index do
    selectable_column
    id_column

    column :photo do |dish|
      if dish.photo.attached?
        image_tag url_for(dish.photo.variant(:card)), class: 'rounded'
      end
    end

    column :name
    column :category
    column :restaurant
    column :price
    column :is_available
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :restaurant
      row :name
      row :category
      row :price
      row :is_available
      row :created_at
      row :updated_at

      row :photo do |dish|
        if dish.photo.attached?
          image_tag url_for(dish.photo.variant(:card))
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs I18n.t('active_admin.dishes.form.basic_info') do
      f.input :restaurant
      f.input :name
      f.input :category
      f.input :price
      f.input :is_available
    end

    f.inputs I18n.t('active_admin.dishes.form.photo') do
      if f.object.photo.attached?
        div do
          image_tag url_for(f.object.photo.variant(:card)),
                    class: 'mb-2 rounded'
        end
      end

      f.input :photo, as: :file
    end

    f.actions
  end
end

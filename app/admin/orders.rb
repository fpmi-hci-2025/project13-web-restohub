# frozen_string_literal: true

ActiveAdmin.register Order do
  menu priority: 4, label: proc { I18n.t('active_admin.orders.menu', default: 'Orders') }

  includes :user, :restaurant, :address

  permit_params :user_id,
                :restaurant_id,
                :address_id,
                :order_type,
                :status,
                :payment_status,
                :total_amount,
                :risk_score,
                :comment

  scope :all, default: true

  Order.statuses.each_key do |st|
    scope I18n.t("active_admin.orders.scopes.statuses.#{st}", default: st.humanize) do |scope|
      scope.where(status: st)
    end
  end

  filter :user
  filter :restaurant
  filter :status, as: :select, collection: Order.statuses.keys
  filter :payment_status, as: :select, collection: Order.payment_statuses.keys
  filter :created_at

  index do
    selectable_column
    id_column
    column :order_number
    column :user
    column :restaurant
    column :status
    column :payment_status
    column :total_amount
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :order_number
      row :user
      row :restaurant
      row :address
      row :order_type
      row :status
      row :payment_status
      row :total_amount
      row :risk_score
      row :comment
      row :created_at
      row :updated_at
    end

    panel I18n.t('active_admin.orders.items_panel', default: 'Order items') do
      table_for order.order_items do
        column :dish
        column :quantity
        column :item_price
      end
    end

    panel I18n.t('active_admin.orders.payments_panel', default: 'Payments') do
      table_for order.payments do
        column :provider
        column :method_type
        column :amount
        column :status
        column :paid_at
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :user
      f.input :restaurant
      f.input :address
      f.input :order_type, as: :select, collection: Order.order_types.keys
      f.input :status, as: :select, collection: Order.statuses.keys
      f.input :payment_status, as: :select, collection: Order.payment_statuses.keys
      f.input :total_amount
      f.input :risk_score
      f.input :comment
    end

    f.actions
  end
end
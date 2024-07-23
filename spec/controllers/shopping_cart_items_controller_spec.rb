require 'rails_helper'

RSpec.describe ShoppingCartItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:shopping_cart_item) { create(:shopping_cart_item, user:, product:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @shopping_cart_items' do
      get :index
      expect(assigns(:shopping_cart_items)).to eq([shopping_cart_item])
    end
  end

  describe 'POST #create' do
    it 'creates a new shopping cart item' do
      expect do
        post :create, params: { shopping_cart_item: { product_id: product.id, quantity: 1 } }
      end.to change(ShoppingCartItem, :count).by(1)
    end

    it 'redirects to the shopping cart index' do
      post :create, params: { shopping_cart_item: { product_id: product.id, quantity: 1 } }
      expect(response).to redirect_to(shopping_cart_items_path)
    end
  end

  describe 'PATCH #update' do
    it 'updates the shopping cart item quantity' do
      patch :update, params: { id: shopping_cart_item.id, shopping_cart_item: { quantity: 2 } }
      shopping_cart_item.reload
      expect(shopping_cart_item.quantity).to eq(2)
    end

    it 'redirects to the shopping cart index' do
      patch :update, params: { id: shopping_cart_item.id, shopping_cart_item: { quantity: 2 } }
      expect(response).to redirect_to(shopping_cart_items_path)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the shopping cart item' do
      shopping_cart_item
      expect do
        delete :destroy, params: { id: shopping_cart_item.id }
      end.to change(ShoppingCartItem, :count).by(-1)
    end

    it 'redirects to the shopping cart index' do
      delete :destroy, params: { id: shopping_cart_item.id }
      expect(response).to redirect_to(shopping_cart_items_path)
    end
  end
end

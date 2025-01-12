class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create_checkout_session
    begin
      session = Stripe::Checkout::Session.create({
        line_items: [{
          price: 'price_1QOoqiBdC2IsMXiiWSn0leCQ',
          quantity: 1,
        }],
        mode: 'payment',
        success_url: Rails.env.production? ? "https://vectorbike-ecfe326f48ab.herokuapp.com/stripe/success?session_id={CHECKOUT_SESSION_ID}" : "http://localhost:3000/stripe/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: Rails.env.production? ? "https://vectorbike-ecfe326f48ab.herokuapp.com/users/#{current_user.id}" : "http://localhost:3000/users/#{current_user.id}",
        client_reference_id: current_user.id
      })

      render json: { id: session.id }
    end
  end

  def success
    session_id = params[:session_id]

    begin
      session = Stripe::Checkout::Session.retrieve(session_id)

      if session.payment_status == 'paid'
        puts('1 session payment status paid')
        Rails.logger.info '1 session payment status paid'
        user = User.find(session.client_reference_id)
        puts('2 user found')
        Rails.logger.info '2 user found'
        amount_paid = session.amount_total / 100.0
        puts('3 amount calculated')
        Rails.logger.info '3 amount calculated'
        user.update_attribute(:balance, user.balance + amount_paid)
        puts('4 updated, maybe?')
        Rails.logger.info '4 updated, maybe?'
        # these do not work :(
        flash[:notice] = "Payment successful! Your balance is now $#{user.balance}0"
      else
        # this doesn't work :(
        flash[:alert] = "Payment failed, please try again."
      end
    rescue Stripe::StripeError => e
      flash[:alert] = "Stripe Error: #{e.message}"
    rescue => e
      flash[:alert] = "Unexpected error: #{e.message}"
    end

    redirect_to user_path(current_user)
  end
end

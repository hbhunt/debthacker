module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user # self to ensure current_user is available outside helper
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token) # ||= assign if @current_user is undefined
	end

	# function to define the '=' method for current_user
	def current_user=(user)
		@current_user = user
	end

	# function to return a boolean if the provided user is the current user
	def current_user?(user)
		user == current_user
	end

	def signed_in?
		!current_user.nil?
	end

	# Friendly Forwarding
	# ====================

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

end

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

	def signed_in?
		!current_user.nil?
	end

end

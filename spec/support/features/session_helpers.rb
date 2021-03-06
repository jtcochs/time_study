module Features
	module SessionHelpers
		def sign_in_with(email, password)
			visit new_user_session_path
			fill_in "Email",    with: email
			fill_in "Password", with: password
			click_button "Sign in"
		end

		def sign_in_as(user)
			sign_in_with(user.email, user.password)
		end
	end
end

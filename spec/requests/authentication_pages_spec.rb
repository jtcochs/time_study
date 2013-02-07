require 'spec_helper'

describe "Authenication pages" do
  subject { page }

  let(:user) { create(:user, email: "user@alameda.org") }

  before do
    visit root_path
  end

  describe "user creation" do
    before { click_link 'Sign up' }

    describe "with valid data" do
      before do
        fill_in "Email", with: "user@alameda.org"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "Sign up"
      end

      it { should have_content("You have signed up successfully.") }
    end

    describe "with invalid data" do
      before do
        fill_in "Email", with: ""
        click_button "Sign up"
      end

      it { should have_content("Email can't be blank") }
    end
  end

  describe "user signin" do
    before do
      click_link "Sign in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
    end
    it { should have_content("Signed in successfully.") }
  end

  describe "authorization" do

    describe "for non-signed-in users" do

      describe "in the Surveys controller" do

        describe "creating a survey" do
          before { click_link "New Survey" }
          it { should have_content("You need to sign in or sign up") }

          describe "after signing in" do
            before do
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the desired protected page" do
              page.should have_selector('h2', text: 'New Survey')
            end
          end
        end
      end
    end
  end
end
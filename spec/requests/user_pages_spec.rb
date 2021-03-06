require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do 
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }

  	before { visit user_path(user) }

  	it { should have_content(user.name) }
    it { should have_content("well on your way") }
  	it { should have_title(user.name) }

    describe "for a 'yellow' user" do
      let(:yellow_user) { FactoryGirl.create(:yellow_user) }
      before { visit user_path(yellow_user) }
      it { should have_content("Some borrowers")}
    end

    describe "for a 'red' user" do
      let(:red_user) { FactoryGirl.create(:red_user) }
      before { visit user_path(red_user) }
      it { should have_content("Forbearance") }
    end

  end

  describe "signup" do
  	before { visit signup_path }

  	let(:submit) { "Create my account" }

  	describe "with invalid information" do
  		it "shoud not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Name", 					                with: "Example User"
  			fill_in "Email", 					                with: "user@example.com"
  			fill_in "user_password", 			            with: "foobar"
  			fill_in "user_password_confirmation", 	  with: "foobar"
  		end

  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end

      describe "after saving the user" do 
        before { click_button submit } 
        let(:user) {User.find_by(email: 'user@example.com')}

        it { should have_link('Sign out')}
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
  	end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before { 
        sign_in user
        visit edit_user_path(user) 
      }

      describe "page" do
        it { should have_content("Update your profile") }
        it { should have_title("Edit user") }
        it { should have_link("change", href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should_not have_content('error') }
      end

      describe "with valid information" do
        let(:new_name) { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name", with: new_name
          fill_in "Email", with: new_email
          click_button "Save changes"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(user.reload.name).to eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end
    end

    describe "index" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
        visit users_path
      end

      it { should have_title('All users') }
      it { should have_content('All users') }

      it "should list each user" do
        User.all.each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end

      describe "pagination" do
        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all) { User.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each user" do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end # should list each user
      end # pagination

      describe "delete links" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end # should be able to delete another user

        it { should_not have_link('delete', href: user_path(admin)) }

      end # delete links
    end # index

  end # / describe signup

end # / describe user pages

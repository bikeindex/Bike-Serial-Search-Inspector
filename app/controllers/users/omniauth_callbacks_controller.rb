class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :ensure_superuser

  def bike_index
    @user = User.from_omniauth(request.env['omniauth.auth'].uid, request.env['omniauth.auth'])
    @user.update_binx_credentials(request.env['omniauth.auth'])
    if @user.persisted?
      FetchBikeIndexBikesJob.perform_later(@user)
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'BikeIndex') if is_navigational_format?
    else
      puts request.env['omniauth.auth']
      flash[:error] = "We're sorry, we failed to sign you in. Please contact admin@bikeindex.org"
      redirect_to root_url
    end
  end
end

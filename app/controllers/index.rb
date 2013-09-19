
enable :sessions

get '/' do
  @urls = Url.order("created_at DESC")
  if session[:message] == "logged_in"
    @user = User.find(session[:user_id])
  end
  # if there are any urls, set the @urls variable with their contents
  # let user create new short URL, display a list of shortened URLs
  erb :index
end

get '/login' do
  erb :login
end

post '/urls' do
  puts "In the /urls post method"
  puts params.inspect
  if Url.create(long_url: params[:long_url], click_count: 0).valid?
    @message = "Successfully shortened new URL"
    @urls = Url.order("created_at DESC")
    erb :index
  else
    @message = "This URL has already been shortened"
    @urls = Url.order("created_at DESC")
    erb :index
  end
end
get '/private' do
  if session[:message] == "logged_in"
    erb :private
  else
    redirect to('/')
  end

end
get '/logout' do
  session[:message] = nil
  redirect to('/')
end

# e.g., /q6bda
get '/:short_url' do
  current_url = Url.find_by_short_url(params[:short_url])
  current_url.click_count += 1
  current_url.save

  redirect to(current_url.long_url)

  # redirect to appropriate "long" URL
end



post '/login' do
  # receive the user's input
  # if valid
  # => create user session
  # => redirect to /private
  # else
  # => send them back home, saying they had an invalid login
  if User.authenticate(params[:email], params[:password])
    session[:message] = "logged_in"
    session[:user_id] = User.find_by_email(params[:email]).id
    redirect to('/private')
  else
    @message = "Email or Password invalid"
    erb :index
  end
end

post '/create' do
  if User.create(params[:info]).valid?
    # create a user session
    # then send them to the private page
    session[:message] = "logged_in"
    redirect to('/private')
  else
    @message = "That email already exists"
    erb :index
  end

end

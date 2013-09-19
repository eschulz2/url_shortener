
enable :sessions

get '/' do
  # params[some shit here]
  @urls = Url.order("created_at DESC")
  if session[:status] == "logged_in"
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

  if Url.create(long_url: params[:long_url], click_count: 0, user_id: session[:user_id]).valid?
    session[:message] = "Successfully shortened new URL"
    @urls = Url.order("created_at DESC")
  else
    session[:message] = "This URL has already been shortened"
    @urls = Url.order("created_at DESC")
  end
  redirect to('/')
end

get '/logout' do
  session.clear
  redirect to('/')
  # redirect to("/?#{some shit here}")
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
  session.clear
  if User.authenticate(params[:email], params[:password])
    session[:status] = "logged_in"
    session[:user_id] = User.find_by_email(params[:email]).id
    redirect to('/')
  else
    @message = "Email or Password invalid"
    erb :index
  end
end

post '/create' do
  session.clear
  if User.create(params[:info]).valid?
    session[:status] = "logged_in"
    redirect to('/')
  else
    session[:message] = "That email already exists"
    erb :index
  end

end


get '/' do
  @urls = Url.order("created_at DESC")
  # if there are any urls, set the @urls variable with their contents
  # let user create new short URL, display a list of shortened URLs
  erb :index
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

# e.g., /q6bda
get '/:short_url' do
  current_url = Url.find_by_short_url(params[:short_url])
  current_url.click_count += 1
  current_url.save

  redirect to(current_url.long_url)

  # redirect to appropriate "long" URL
end

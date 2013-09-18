
get '/' do
  # if there are any urls, set the @urls variable with their contents
  # let user create new short URL, display a list of shortened URLs
  erb :index
end

post '/urls' do
  # create a new Url
end

# e.g., /q6bda
get '/:short_url' do
  # redirect to appropriate "long" URL
end

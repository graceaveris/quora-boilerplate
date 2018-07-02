set :run, true

get '/' do
  erb :"user/home"
end


#a get will return something to the user
get '/signup' do
	erb :"user/signup"
end


#a post will add something back to the server, eg add to database o
post '/signup' do
  x = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], username: params[:username], password: params[:password])
  if x.save
  	session[:id] = x.id
  	redirect "/users/#{current_user.username}"
  else
    flash[:error] = "Email must be valid, and all fields filled out"
  	redirect '/signup'
  end
end

#LOGIN PAGE
get '/login' do
    erb :"user/login"
end

#AUTHENTICATE LOGIN
post '/login' do 
	@x = User.find_by(email: params[:email])

	if @x && @x.authenticate(params[:password])
      session[:id] = @x.id
      redirect "/users/#{current_user.username}"
   
  elsif @x
    	flash[:error] = "incorrect password"
    	redirect'/login'
  
  else flash[:error] = "email does not exist"
    	redirect'/login'
  end
end

#LOGOUT clears the session
get '/log_out' do
	session.clear
	redirect '/'
end

#PROFILE PAGE AND URL GENERATOR
get '/users/:username' do
  @user = User.find_by(username: params[:username])
  @questions = @user.questions
  erb :'user/user_home'
end




require_relative './config/init.rb'

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
  	redirect "/user/users/#{current_user.username}"
  else
    flash[:error] = "Must be a valid email address"
  	redirect '/user/signup'
  end
end

#LOGIN PAGE
get '/login' do
    erb :"user/login"
end

#AUTHENTICATE LOGIN
post '/login' do 
	@x = User.find_by(email: params[:email])
  # byebug

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
	redirect 'user/'
end

#PROFILE PAGE AND URL GENERATOE
get '/users/:username' do
  @user = User.find_by(username: params[:username])
  @questions = @user.questions
  erb :'user/user_home'
end

#QUESTIONS PAGE = LISTS ALL QUESTIONS
get '/questions' do
@questions = Question.all
  erb :'questions/questions'
end

#ADD QUESTION TO DATABASE / a post will add our question back to the database
post '/questions' do
  x = Question.create(user_id: current_user.id, user_question: params[:newquestion])
  flash[:notice] = "Question added!"
  redirect'/questions'

end

#INDIVIDUAL QUESTION PAGE / THIS SHOWS THE QUESTION SELECTED, AND DISPLAYS CURRENT ANSWERS.
get '/questions/:id' do
  @question = Question.find(params[:id])
   # @answers = @question.answers #ORIGINAL LINE, WITHOUT THE VOTE ORDER
  @answers = Answer.where(question_id: @question.id).left_joins(:votes).group(:id).order('COUNT(votes.id) DESC').limit(10)
  erb :'questions/show'
end

#ADD AN ANSWER / ADD A TO DATABSE AND DISPLAY
post '/answers' do
  Answer.create(question_id: params[:questionid], user_answer: params[:newanswer])#WORKING!
  redirect "/questions/#{params[:questionid]}"

end

#UPDATE THE QUESTION
patch '/update' do
question = Question.find(params[:questionid])
question.user_question = params[:updatedquestion]
question.save
redirect"/questions/#{params[:questionid]}"
end

#ADD A VOTE
post '/vote' do
  Vote.create(answer_id: params[:answerid])#WORKING!
  redirect "/questions/#{params[:questionid]}"

end


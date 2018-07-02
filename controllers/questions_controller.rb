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


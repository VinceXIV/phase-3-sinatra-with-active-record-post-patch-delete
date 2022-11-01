class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  delete '/reviews/:id' do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  post '/reviews' do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      created_at: params[:created_at],
      updated_at: params[:updated_at],
      user_id: params[:user_id]
    )

    review.to_json
  end

  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.score = params[:score] || review.score
    review.comment = params[:comment] || review.comment
    review.game_id = params[:game_id] || review.game_id
    review.user_id = params[:user_id] || review.user_id

    review.save
    Review.find(params[:id]).to_json    
  end

end

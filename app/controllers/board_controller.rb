class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :set_post, except: [:index, :new, :create]
  # 로그인 된 상태에서만 접속할 수 있는 페이지?
  # index, show만 로그인 하지 않은 상태에서 볼 수 있게 할 것.
  # 나머지는 반드시 로그인이 필요하다.
  before_action :authenticate_user!, except: [:index, :show]
  
  
  def index
    @posts = Post.all
    #@current_user = current_user
    #p current_user
  end

  def show
  end

  def new
  end
  
  def create
    post = Post.new
    post.title = params[:title]
    post.contents = params[:contents]
    post.user_id = current_user.id
    post.save
    
    # post를 등록시 이 글을 작성한 사람은 현재 로그인 되어 있는 유저.
    
    redirect_to "/board/#{post.id}"
  end

  def edit

  end
  
  def update
  
    @post.title = params[:title]
    @post.contents = params[:contents]
    @post.save
    
    redirect_to "/board/#{@post.id}"
    
  end
  
  def destroy
  
    @post.destroy
    
    redirect_to "/boards"
  end
  
  
  def set_post
    @post = Post.find(params[:id])
  end
end

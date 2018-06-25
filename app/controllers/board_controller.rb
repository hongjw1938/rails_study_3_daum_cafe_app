class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :set_post, except: [:index, :new, :create]
  # 로그인 된 상태에서만 접속할 수 있는 페이지?
  # index, show만 로그인 하지 않은 상태에서 볼 수 있게 할 것.
  # 나머지는 반드시 로그인이 필요하다.
  before_action :authenticate_user!, except: [:index, :show, :test]
  
  
  def index
    @posts = Post.all
    #@current_user = current_user
    #p current_user
    @title = "이거는 인덱스"
  end

  def show
  end

  def new
  end
  
  def create
    
    # new와 save를 모두 실행해준다.
    # post_params에는 hash 타입으로 정보를 저장하고 있다.
    post = Post.create(post_params)
    
    
    # post를 등록시 이 글을 작성한 사람은 현재 로그인 되어 있는 유저.
    
    redirect_to "/board/#{post.id}"
  end

  def edit

  end
  
  def update
    p post_params
    # save를 실행해 주므로 save가 필요없다.
    @post.update(post_params)

    
    redirect_to "/board/#{@post.id}"
    
  end
  
  def destroy
  
    @post.destroy
    
    redirect_to "/boards"
  end
  
  def test
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    {title: params[:title], contents: params[:contents], user_id: current_user.id}
  end
end

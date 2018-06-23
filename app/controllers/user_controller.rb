class UserController < ApplicationController
  def index
    @users = User.all
    @current_user = User.find(session[:current_user]) if session[:current_user]
    #p session
  end
  
  def new
    
  end
  
  def create
    user = User.new
    user.user_name = params[:user_name]
    user.password = params[:password]
    user.ip_address = request.ip
    
    user.save
    
    redirect_to "/user/#{user.id}"
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.password = params[:password]
    user.save
    
    redirect_to "/user/#{user.id}"
    
  end

  def show
    @user = User.find(params[:id])
  end
  
  def sign_in
    # 로그인 되어 있는 경우 이전 페이지로 돌아감.
    # 로그인 되어 있지 않은 경우 로그인페이지로
  end
  
  def login
    # 실제로 유저가 입력한 ID, PW를 바탕으로 
    # 로그인이 작동되는 곳.
    id = params[:user_name]
    pw = params[:password]
    
    # 사용자의 고유 번호를 알 수 없으므로 아이디로 찾아야 한다.
    user = User.find_by_user_name(id)
    
    
    # 해당 user_name으로 가입한 유저가 있고, 비밀번호가 일치하는 경우
    if !user.nil? and user.password.eql?(pw)
      session[:current_user] = user.id
      flash[:success] = "로그인에 성공했습니다."
      
      redirect_to '/users'
      
    # 유저가 없거나 비밀번호가 일치하지 않는 경우  
    else
      flash[:error] = "가입된 유저가 없거나 비밀번호가 다릅니다."
      redirect_to "/sign_in"
    end
  end
  
  def logout
    # 키이름에 맞추어 delete
    session.delete(:current_user)
    flash[:success] = "로그아웃 되었습니다."
    
    redirect_to "/users"
  end
end

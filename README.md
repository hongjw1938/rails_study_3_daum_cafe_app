### 7. daum_cafe_app 만들기
** rails app 생성
    - rails _5.0.6_ new name
    * 모델 생성
        - rails g model post
    * controller 생성
        - rails g controller board index show new edit
        - 뒤의 parameter를 주면 view파일도 동시에 생성가능
* route 지정
    - RESTful 한 방식으로 지정할 것.
    - 수정 : put, patch
    - 삭제 : delete
* 세션을 이용한 로그인 시스템 만들기
    - `session[:지정hash]` : 이를 이용해 특정 hash key에 value를 저장할 수 있다.
    - 일반적으로 고유한 id를 찾을 수 없으므로 login을 구현시, id를 이용해 찾아야 한다.
        >> 유저가 존재하는지 확인하기 위해 `nil?`을 사용. 비밀번호 일치 여부 확인을 위해 `eql?`사용
        >> 검색한 내용을 활용시 `empty?`를 사용해 비어있는지 확인할 수 있다.
        >> 존재여부를 묻는 경우 `present?`를 사용할 수도 있다.
        `user.present?`
        >> `find_by_column명(params[:parameter명])`으로 찾는다.
    - id를 찾아서 db에 저장된 객체를 찾았으면 해당 id에 따른 고유한 값을 `session[:current_name]`과 같이 hash타입에 저장한다.
    - 이에 따라 현재 로그인된 유저 정보를 index에 보여줄 수 있다.
        >> `model명.find(session[:current_name]) if session[:current_name]`으로 찾고 변수에 저장해 사용할 수 있다.
* 코드 줄이기
    - 동일한 코드의 반복을 줄일 필요가 있다. 하나의 메소드로 관리
        >> `def set_post`
               `@post = Post.find(params[:id])`
            `end`
        >> 위와 같이 하나의 메소드로 코드를 지정하면 하나의 요청에서는 해당 값이 유지되어 사용된다.
        >> 이러한 사용방식을 택할 경우, 변수는 다른 곳에서도 반드시 일치시켜야 한다.
        >> 그러나 코드 중복 자체는 줄일 수 없음.
        >> 따라서, filter를 사용해 코드 중복을 줄일 수 있다.
    - filter??
        >> Filters are methods that are run "before", "after" or "around" a controller action.
        >> `before_action :require_login`와 같이 사용할 수 있다.
        >> 그러나 모든 action에 대해 지정하면 오류가 날 수 있으므로, 특정 경우에만 사용토록 해야 한다.(only)
        >> `before_action :set_post, only: [:show, :edit, :update, :destroy]`
        >> `before_action :set_post, except: [:index, :new, :create]` : 이와 같이 제외하는 방식으로 사용해도 된다.
    - application_controller이용
        >> 현재 로그인된 유저 확인, 로그인 상태 확인 메소드 생성
        >> 어디서든 메소드를 불러 즉각적으로 사용할 수 있음.
        >> 따라서 해당 코드를 다른 컨트롤러에서 사용 가능.
        >> 이를 통해 특정 액션의 경우 로그인된 상태에서만 입장할 수 있게 하려면?
            `def authenticate_user!`
            `   unless user_signed_in?`
            `    redirect_to '/sign_in'`
     
            `    end`
            `end`
        >> 위와 같이 메소드를 지정한 다음 board_controller에 filter를 사용
            `before_action :authenticate_user!, except: [:index, :show]`
        >> View file에서 controller에 있는 action을 사용하기 위해 시도하는 경우
            - 단순히 사용하면 선언되지 않은 메소드라고 오류를 내보낸다.
            - Cycle상, controller에 있던 메소드를 거쳐서 view로 넘어온 것이기 때문에 다시 돌아가서 확인할 수가 없는 것이다.
            - 따라서, helper_method를 사용한다.
            - `helper_method :메소드명` 과 같이 사용할 수 있다.
* 한명의 유저가 여러 글을 작성(1:n 구조 구현)
    - 유저가 1이고 글(post)가 n이다. 따라서 다음과 같이 rb file에 작성할 수 있다.
        >> user.rb에 넣을 코드 : `has_many :posts`
        >> post.rb에 넣을 코드 : `belongs_to :users`
        >> 반드시 복수형으로 지정해야 한다.
    - db를 변경한다. 모델명_id를 통해 foreign key를 지정할 수 있다.
        >> `t.integer :user_id`
        >> 위와 같이 posts table에 칼럼을 추가하여 외래키를 지정할 수 있다.
        >> 외래키 지정시에는 `:foreign_key true`로 속성을 줄 수 있지만, 만약 table이 post가 먼저 만들어지고 user가 이후에 만들어지는 경우에는 불가능.
        >> rails c를 통해 command하고 특정 유저를 만들고 post객체를 만든 다음 post를 채워넣고
            ->> `u.posts`, `p.user`를 통해 user가 작성한 post들, post를 작성한 user 정보를 확인할 수 있다.
    - 이에 따라 controller에서 post를 create할 때마다 user의 id를 저장해야 한다.
        >> `post.user_id = current_user.id`로 application_controller에 있는 current_user메소드를 호출하고
        >> 세션에 저장된 user_id를 통해 User모델에서 객체를 찾고 고유한 해당 id값을 저장한다.
    - 위 과정으로 외래키를 지정할 수 있으며, user / post를 연결해 각각에 대해 쿼리할 수 있다.
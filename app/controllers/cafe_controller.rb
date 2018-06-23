class CafeController < ApplicationController
    def new
    
    end
    
    def create
        cafe = Cafe.new
        cafe.title = params[:title]
        cafe.description = params[:description]
        
        cafe.save
        
        redirect_to "/cafe/#{cafe.id}"
    end
    
    def show
        @cafe = Cafe.find(params[:id])
    end
    
    def index
        @cafes = Cafe.all
    end
    
    
    def edit
       @cafe = Cafe.find(params[:id]) 
    end
    def update
        cafe = Cafe.find(params[:id])
        cafe.title = params[:title]
        cafe.description = params[:description]
        
        cafe.save
        
        redirect_to "/cafe/#{cafe.id}"
    end
    
    def destroy
        cafe = Cafe.find(params[:id])
        cafe.destroy
        
        redirect_to "/cafe/index"
    end
end

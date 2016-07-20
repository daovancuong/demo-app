class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:update, :edit]

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
    save_micropost @micropost
    @like=@micropost.likes.build
    @comment= @micropost.comments.build
    @comments=@micropost.comments.paginate(page: params[:page])

  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success]="create post success"
      redirect_to root_url
    else
      message=""
      if params[:micropost][:title].empty?
        message+="title is not empty"
      end
      if params[:micropost][:content].empty?
        message+=",content is not empty"
      end
      flash[:warning]=message
      redirect_to root_url
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    flash[:success]="delete success"
    redirect_to request.referer || root_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def micropost_params
    params.require(:micropost).permit(:content, :picture, :title)
  end
end
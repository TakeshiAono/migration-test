class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    #変更
    @tasks = current_user.tasks
    #@tasks = @tasks.order(created_at: "DESC")
    #binding pry
    @tasks = @tasks.order(deadline: "DESC") if params[:sort_expired]
    #binding pry
    @tasks = @tasks.order(priority: "ASC") if params[:sort_priority]
    if params[:search]
      #if params[:search][:title_search].present? && params[:search][:status_search].present?
        @tasks = @tasks.search_and(params[:search][:title_search], params[:search][:status_search]).status_search(params[:search][:status_search]).title_search(params[:search][:title_search])
      #elsif params[:search][:status_search].present?
        #@tasks = Task.status_search(params[:search][:status_search])
      #elsif  params[:search][:title_search].present?
        #@tasks = Task.title_search(params[:search][:title_search])
      #end
    end
    @tasks = @tasks.order(created_at: "DESC").page(params[:page]).per(4)
  end

  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: t('controller.successfully_created') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t('controller.successfully_updated') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('controller.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :created_at, :deadline, :status, :priority)
    end
end

class TwitterConfigsController < ApplicationController

  before_filter :login_required
  # GET /twitter_configs
  # GET /twitter_configs.xml
  def index
    #@twitter_configs = TwitterConfig.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_configs }
    end
  end

  # GET /twitter_configs/1
  # GET /twitter_configs/1.xml
  def show
    #@twitter_config = TwitterConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @twitter_config }
    end
  end

  # GET /twitter_configs/new
  # GET /twitter_configs/new.xml
  def new
    if request.referer.include?('preference')
      session[:after_twitter] = request.referer 
    else
      session[:after_twitter] = '/sites'
    end
    @twitter_config = TwitterConfig.new
    @twitter_config = current_user.twitter_config || TwitterConfig.new(:user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @twitter_config }
    end
  end

  # GET /twitter_configs/1/edit
  def edit
    #@twitter_config = TwitterConfig.find(params[:id])
  end

  # POST /twitter_configs
  # POST /twitter_configs.xml
  def create
    #@twitter_config = TwitterConfig.new(params[:twitter_config])
    twitter_config = params[:twitter_config]
    created = current_user.twitter_config
    @twitter_config = TwitterConfig.new(twitter_config.merge({:user_id => current_user.id})) unless created
    @twitter_config = created unless created.nil?
    @twitter_config.attributes = twitter_config.merge({:user_id => current_user.id})

    respond_to do |format|
      if @twitter_config.save
        flash[:notice] = 'Twitter Configuration was successfully saved.'
        format.html { redirect_to(session[:after_twitter]) }
        format.xml  { render :xml => @twitter_config, :status => :created, :location => @twitter_config }
      else
        flash[:error] = "We could not log you into to twitter. Please make sure your twitter details are correct."
        format.html { render :action => "new" }
        format.xml  { render :xml => @twitter_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_configs/1
  # PUT /twitter_configs/1.xml
  def update
    #@twitter_config = TwitterConfig.find(params[:id])

    respond_to do |format|
      if @twitter_config.update_attributes(params[:twitter_config])
        flash[:notice] = 'TwitterConfig was successfully updated.'
        format.html { redirect_to(@twitter_config) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @twitter_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_configs/1
  # DELETE /twitter_configs/1.xml
  def destroy
    #@twitter_config = TwitterConfig.find(params[:id])
    @twitter_config.destroy

    respond_to do |format|
      format.html { redirect_to(twitter_configs_url) }
      format.xml  { head :ok }
    end
  end
end

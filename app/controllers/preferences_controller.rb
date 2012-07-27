class PreferencesController < ApplicationController
  before_filter :login_required
  before_filter :find_site
  # GET /preferences
  # GET /preferences.xml
  def find_site
    @site = Site.find_by_id(params[:site_id])
  end

  def index
    @preferences = Preference.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preferences }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference = Preference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/new
  # GET /preferences/new.xml
  def new
    created = Preference.find(:first, :conditions => { :site_id => @site.id, :user_id => current_user.id})
    @preference = Preference.new(:site_id => @site.id)
    @preference = created unless created.nil?
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
    @preference = Preference.find(params[:id])
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    #@preference = Preference.new(params[:preference])
    preference = params[:preference]
    preference[:twitter_only] = preference[:twitter_only] == "on" ? true : false
    preference[:twitter_self] = preference[:twitter_self] == "on" ? true : false
    preference[:twitter_all] = preference[:twitter_all] == "on" ? true : false
    created = Preference.find(:first, :conditions => { :site_id => preference[:site_id], :user_id => current_user.id })
    @preference = Preference.new(preference.merge({:user_id => current_user.id})) unless created
    @preference = created unless created.nil?
    @preference.attributes = preference.merge({:user_id => current_user.id})

    respond_to do |format|
      if @preference.save
        flash[:notice] = 'Preference was successfully stored.'
        format.html { redirect_to sites_path }
        format.xml  { render :xml => @preference, :status => :created, :location => @preference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        flash[:notice] = 'Preference was successfully updated.'
        format.html { redirect_to(@preference) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.xml
  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to(preferences_url) }
      format.xml  { head :ok }
    end
  end
end

class BcardsController < ApplicationController
  # GET /bcards
  # GET /bcards.xml
  def index
    @bcards = Bcard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bcards }
    end
  end

  # GET /bcards/1
  # GET /bcards/1.xml
  def show
    @bcard = Bcard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bcard }
    end
  end

  # GET /bcards/new
  # GET /bcards/new.xml
  def new
    @bcard = Bcard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bcard }
    end
  end

  # GET /bcards/1/edit
  def edit
    @bcard = Bcard.find(params[:id])
  end

  # POST /bcards
  # POST /bcards.xml
  def create
    @bcard = Bcard.new(params[:bcard])

    respond_to do |format|
      if @bcard.save
        format.html { redirect_to(@bcard, :notice => 'Bcard was successfully created.') }
        format.xml  { render :xml => @bcard, :status => :created, :location => @bcard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bcards/1
  # PUT /bcards/1.xml
  def update
    @bcard = Bcard.find(params[:id])

    respond_to do |format|
      if @bcard.update_attributes(params[:bcard])
        format.html { redirect_to(@bcard, :notice => 'Bcard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bcards/1
  # DELETE /bcards/1.xml
  def destroy
    @bcard = Bcard.find(params[:id])
    @bcard.destroy

    respond_to do |format|
      format.html { redirect_to(bcards_url) }
      format.xml  { head :ok }
    end
  end
end

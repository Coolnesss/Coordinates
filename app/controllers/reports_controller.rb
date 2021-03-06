class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :ignore]
  before_action :ensure_that_signed_in, except: [:new, :create]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.includes(:position).where.not(position: nil).where(ignored: false).order(:cause)
  end

  def ignore
    @report.ignore
    redirect_to reports_path, notice: "Ignored report."
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    update_helper(@report, report_params)
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    destroy_helper(@report)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:email, :description, :cause, :position_id, :ignored, :fb_id)
    end
end

class PatientsController < ApplicationController
  before_action :set_patient, only: %i[ show edit update destroy ]

  # GET /patients or /patients.json
  def index
    @patients = Patient.all
  end

  # GET /patients/1 or /patients/1.json
  def show
    query = "SELECT u.name as d_name, dc.name as dc_name, a.appointment_date, aps.name as aps_name, a.recomendations
      FROM appointments a
      inner join appointment_statuses aps on a.appointment_status_id=aps.id
      inner join doctors d on a.doctor_id=d.id
      inner join doctor_categories dc on d.doctor_category_id=dc.id
      inner join users u on d.user_id=u.id
      WHERE a.patient_id=?"
    @doctor_categories = DoctorCategory.all
    @doctors_by_category = Doctor.select('users.name as u_name, doctor_categories.name as dc_name, doctors.id as d_id').joins(:doctor_category, :user).all
    @appointments = Appointment.find_by_sql( [query, @patient.id] )
  end

  def doctors_search
    if params[:doctor_category_id].present?
      @doctors_by_category = Doctor.select('users.name as u_name, doctor_categories.name as dc_name, doctors.id as d_id').joins(:doctor_category, :user).where("doctor_category_id = ?", params[ :doctor_category_id ])
    else
      @doctors_by_category = Doctor.select('users.name as u_name, doctor_categories.name as dc_name, doctors.id as d_id').joins(:doctor_category, :user).all
    end
    respond_to do |format|
      format.js {render layout: false} # Add this line to you respond_to block
    end
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients or /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to patient_url(@patient), notice: "Patient was successfully created." }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to patient_url(@patient), notice: "Patient was successfully updated." }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1 or /patients/1.json
  def destroy
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url, notice: "Patient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def patient_params
      params.fetch(:patient, {})
    end
end

class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /patients/new
  def new
    @appointment = Appointment.new
    @doctor = Doctor.select('doctors.id as d_id, users.name as u_name, doctor_categories.name as dc_name').joins(:doctor_category, :user).where("doctors.id = ?", params[ :doctor_id ]).first
    # @patient = Patient.select('patients.id as p_id, users.name').joins(:user).where("user_id = ?", current_user.id).first
    @patient = Patient.find_by(user_id: current_user.id)
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to '/patients/' + @appointment.patient_id.to_s, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @patient }
      else
        puts @appointment.errors.inspect
        format.html { redirect_to '/appointments/new/' + @appointment.doctor_id.to_s, alert: @appointment.errors.full_messages }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @appointment = Appointment.find(params[:id])
    @patient = Patient.select('*').joins( :user ).find_by( id: @appointment.patient_id )

  end

  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to doctor_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params
        .fetch(:appointment, {})
        .permit(:id, :appointment_date, :doctor_id, :patient_id, :appointment_status_id, :recomendations)
        .with_defaults(appointment_status_id: 1)
    end

end

class Project < ActiveRecord::Base
	has_many :tasks
	#### in migration does t.references does that include user_id automatically

	validates :name, presence: true

	def self.velocity_length_in_days
		21
	end

	def incomplete_tasks
		tasks.reject(&:complete?)
	end


	def done?
		incomplete_tasks.empty?
	end

	def total_size
		tasks.to_a.sum(&:size)
	end

	def remaining_size
		incomplete_tasks.sum(&:size)
	end

	###### Why can you do :points_to_velocity in Project when its from Task??
	def completed_velocity
		tasks.to_a.sum(&:points_toward_velocity)
	end

	def current_rate
		completed_velocity * 1.0 / Project.velocity_length_in_days
	end

	def projected_days_remaining
		remaining_size / current_rate
	end

	###### you can add numbers to dates?
	def on_schedule?
		return false if projected_days_remaining.nan?
		(Date.today + projected_days_remaining) <= due_date
	end

	
end
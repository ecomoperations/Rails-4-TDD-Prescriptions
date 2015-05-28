class Task < ActiveRecord::Base
	belongs_to :project

	# def initialize(options = {}) 
	# 	mark_completed(options[:completed_at]) if options[:completed_at]
	# 	@size = options[:size]
	# end
	### Active Record vs intialize


	def mark_completed(date = nil)
		self.completed_at = (date || Time.current)
	end

	def complete?
		completed_at.present?
	end

	##### shouldnt this be less than(<)
	def part_of_velocity?
		return false unless complete?
		completed_at > Project.velocity_length_in_days.days.ago
	end

	def points_toward_velocity
		if part_of_velocity? then size else 0 end
	end

end
require 'rails_helper'

describe CreatesProject do 

	it "creates a project given a name" do
		creator = CreatesProject.new(name: "Project Runway")
		creator.build
		expect(creator.project.name).to eq("Project Runway")
	end

	describe "task string parsing" do
		it "handles an empty string" do
			creator = CreatesProject.new(name: "Test", task_string: "")
			tasks = creator.convert_string_to_tasks
			expect(tasks.size).to eq(0)
		end

		it "handles a single string" do
			creator = CreatesProject.new(name: "Test", task_string: "Start Things")
			tasks = creator.convert_string_to_tasks
			expect(tasks.size).to eq(1)
			expect(tasks.map(&:title)).to eq(["Start Things"])
			expect(tasks.map(&:size)).to eq([1])
		end

		it "handles a single string with size" do
			creator = CreatesProject.new(name: "Test", task_string: "Start Things:3")
			tasks = creator.convert_string_to_tasks
			expect(tasks.size).to eq(1)
			expect(tasks.map(&:title)).to eq(["Start Things"])
			expect(tasks.map(&:size)).to eq([3])
		end

		it "handles multiple tasks" do
			creator = CreatesProject.new(name: "Test", task_string: "Start Things:3\nEnd Things:2")
			tasks = creator.convert_string_to_tasks
			expect(tasks.size).to eq(2)
			expect(tasks.map(&:title)).to eq(["Start Things", "End Things"])
			expect(tasks.map(&:size)).to eq([3,2])
		end

		it "attaches tasks to the project" do
			creator = CreatesProject.new(name: "Test", task_string: "Start Things:3\nEnd Things:2")
			creator.create
			expect(creator.project.tasks.size).to eq(2)
			expect(creator.project).not_to be_a_new_record
		end
	end
end
# frozen_string_literal: true

rake_application = Rake.application

Dir[File.join(__dir__, 'tasks', '*.rake')].each do |file|
  rake_application.add_import file
end

task default: %i[spec rubocop]

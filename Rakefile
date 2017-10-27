# frozen_string_literal: true

rake_application = Rake.application

Dir[File.join(__dir__, 'tasks', '*.rake')].each { |file| rake_application.add_import file }

task default: [:spec, :rubocop]

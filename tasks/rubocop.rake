# frozen_string_literal: true

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |task|
    task.options = ['-D']
  end
rescue LoadError
  warn "'rubocop' gem is not loaded."
end

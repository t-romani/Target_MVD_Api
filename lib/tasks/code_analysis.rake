require 'rubocop/rake_task'
require 'reek/rake/task'
require 'rails_best_practices/rake_task'

task :code_analysis do
  RuboCop::RakeTask.new(:rubocop)
  Rake::Task['rubocop'].invoke

  Reek::Rake::Task.new(:reek)
  Rake::Task['reek'].invoke

  RailsBestPractices::RakeTask.new
  Rake::Task['rails_best_practices'].invoke
end

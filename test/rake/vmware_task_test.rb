require 'test/test_helper'
require 'rake'

class VMwareTaskTest < Test::Unit::TestCase
  attr_reader :rake

  def setup
    @rake = Rake.application = Rake::Application.new.extend(RakeAssertions)
    @rake.test = self
  end

  subject do
    Captain::Rake::VMwareTask
  end

  should 'define a file task' do
    subject.new
    rake.should_have_task('vm.vmwarevm').
                  of_type(Rake::FileTask).
             depending_on()

  end

  should 'depend on any given iso image' do
    task = subject.new do |task|
      task.iso_image = 'foo.iso'
    end

    rake.should_have_task(task.virtual_machine.path).
             depending_on('foo.iso')
  end

  should 'define a task' do
    task = subject.new

    rake.should_have_task('vmware').
             depending_on(task.virtual_machine.path).
         with_description('Build a VMware virtual machine')
  end
end

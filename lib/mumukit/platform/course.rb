module Mumukit::Platform::Course
  extend Mumukit::Platform::Global

  def self.find_by_slug!(slug)
    Mumukit::Platform.course_class.find_by_slug!(slug)
  end

  def self.__global_thread_variable_key__
    :course
  end
end

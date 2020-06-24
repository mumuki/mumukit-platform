module Mumukit::Platform::Global
  def switch!(global)
    raise "#{__global_thread_variable_key__} must not be nil" unless global
    Thread.current[__global_thread_variable_key__] = global
  end

  def leave!
    Thread.current[__global_thread_variable_key__] = nil
  end

  def current
    Thread.current[__global_thread_variable_key__] || raise("#{__global_thread_variable_key__} not selected")
  end

  def current?
    !!Thread.current[__global_thread_variable_key__]
  end
end


require 'perf/version'

class << Perf
  def record(*args, &block)
    with_perf('record', *args, &block)
  end

  def stat(*args)
    with_perf('stat', *args, &block)
  end

  private

  def with_perf(*args)
    if ENV['USER'] == 'root'
      pid = Process.spawn('perf', *args, '-p', Process.pid.to_s)
    end
    yield
  ensure
    if pid
      Process.kill(:INT, pid)
      Process.wait(pid)
    end
  end
end

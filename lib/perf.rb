require 'perf/version'

class << Perf
  def record(*args, count: nil, call_graph: nil, &block)
    args = args.dup
    if count
      args.push('-c', count.to_s)
    end
    if call_graph
      call_graph = 'fp' if call_graph == true
      args.push('--call-graph', call_graph.to_s)
    end
    with_perf('record', *args, &block)
  end

  def stat(*args, event: nil, &block)
    if event
      args = args.dup.push('-e', event.join(','))
    end
    with_perf('stat', *args, &block)
  end

  private

  def with_perf(*args, count: nil)
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

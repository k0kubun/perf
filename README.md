# Perf

Use Linux perf for some region of Ruby code easily.

## Usage

Run as root to use perf. Otherwise it just executes a given block.


### perf record

```rb
def bench
  ERB.new('<%= 1 %>').render
end

10000.times { bench }
RubyVM::MJIT.pause

Perf.record do
  50000.times { bench }
end
```

### perf stat

```rb
Perf.stat('-e', 'cycles,instructions,branches,branch-misses') do
  50000.times { bench }
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

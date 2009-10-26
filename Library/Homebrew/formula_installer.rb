require 'beer_events'
require 'formula'
require 'set'

def ignore_interrupts
  std_trap = trap("INT") {}
  yield
ensure
  trap("INT", std_trap)
end

class FormulaInstaller
  @@attempted = Set.new

  def initialize
    @install_deps = true
  end

  attr_writer :install_deps

  def expand_deps f
    deps = []
    f.deps.collect do |dep|
      dep = Formula.factory dep
      deps += expand_deps dep
      deps << dep
    end
    deps
  end

  def install f    
    expand_deps(f).each do |dep|
      begin
        install_private dep unless dep.installed?
      rescue
        #TODO continue if this is an optional dep
        raise
      end
    end if @install_deps
    
    install_private f
  end
  
  private

  def install_private f
    return if @@attempted.include? f.name
    @@attempted << f.name

    # 1. formulae can modify ENV, so we must ensure that each
    #    installation has a pristine ENV when it starts, forking now is 
    #    the easiest way to do this
    # 2. formulae have access to __END__ the only way to allow this is
    #    to make the formula script the executed script
    read, write = IO.pipe
    # I'm guessing this is not a good way to do this, but I'm no UNIX guru
    ENV['HOMEBREW_ERROR_PIPE'] = write.to_i.to_s

    watch_out_for_spill do
      fork do
        begin
          read.close
          exec '/usr/bin/ruby', '-I', File.dirname(__FILE__), '-rinstall', f.path, '--', *ARGV.options
        rescue => e
          Marshal.dump(e, write)
          write.close
          exit! 1
        end
      end
      ignore_interrupts do
        write.close
        Process.wait
        data = read.read
        raise Marshal.load(data) unless data.nil? or data.empty?
        raise "Suspicious installation failure" unless $?.success?
      end
    end
  end
end

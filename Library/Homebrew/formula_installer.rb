require 'formula'
require 'set'

class FormulaInstaller
  @@attempted = Set.new

  def initialize
    @install_deps = true
  end

  attr_writer :install_deps

  def self.expand_deps f
    deps = []
    f.deps.collect do |dep|
      dep = Formula.factory dep
      deps += expand_deps dep
      deps << dep
    end
    deps
  end

  def pyerr dep
    brew_pip = ' brew install pip &&' unless Formula.factory('pip').installed?
    <<-EOS.undent
    Unsatisfied dependency, #{dep}
    Homebrew does not provide Python dependencies, pip does:

        #{brew_pip} pip install #{dep}
    EOS
  end
  def plerr dep; <<-EOS.undent
    Unsatisfied dependency, #{dep}
    Homebrew does not provide Perl dependencies, cpan does:

        cpan -i #{dep}
    EOS
  end
  def rberr dep; <<-EOS.undent
    Unsatisfied dependency "#{dep}"
    Homebrew does not provide Ruby dependencies, rubygems does:

        gem install #{dep}
    EOS
  end
  def jrberr dep; <<-EOS.undent
    Unsatisfied dependency "#{dep}"
    Homebrew does not provide JRuby dependencies, rubygems does:

        jruby -S gem install #{dep}
    EOS
  end

  def check_external_deps f
    return unless f.external_deps

    f.external_deps[:python].each do |dep|
      raise pyerr(dep) unless quiet_system "/usr/bin/env", "python", "-c", "import #{dep}"
    end
    f.external_deps[:perl].each do |dep|
      raise plerr(dep) unless quiet_system "/usr/bin/env", "perl", "-e", "use #{dep}"
    end
    f.external_deps[:ruby].each do |dep|
      raise rberr(dep) unless quiet_system "/usr/bin/env", "ruby", "-rubygems", "-e", "require '#{dep}'"
    end
    f.external_deps[:jruby].each do |dep|
      raise rberr(dep) unless quiet_system "/usr/bin/env", "jruby", "-rubygems", "-e", "require '#{dep}'"
    end
  end

  def check_formula_deps f
    FormulaInstaller.expand_deps(f).each do |dep|
      begin
        install_private dep unless dep.installed?
      rescue
        #TODO continue if this is an optional dep
        raise
      end
    end
  end

  def install f
    if @install_deps
      check_external_deps f
      check_formula_deps f
    end
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

     begin #watch_out_for_spill do #disabled temporarily, see Issue #124
      fork do
        begin
          read.close
          exec '/usr/bin/nice', '/usr/bin/ruby', '-I', File.dirname(__FILE__), '-rinstall', f.path, '--', *ARGV.options_only
        rescue => e
          Marshal.dump(e, write)
          write.close
          exit! 1
        end
      end
      ignore_interrupts do # because child proc will get it and marshall it back
        write.close
        Process.wait
        data = read.read
        raise Marshal.load(data) unless data.nil? or data.empty?
        raise "Suspicious installation failure" unless $?.success?
      end
    end
  end
end

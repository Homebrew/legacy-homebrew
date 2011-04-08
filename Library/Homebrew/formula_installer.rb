require 'exceptions'
require 'formula'
require 'set'

class FormulaInstaller
  attr :ignore_deps, true

  def initialize f
    @f = f
  end

  # raises Homebrew::InstallationErrors in the event of install failures
  def go
    if @f.installed? and not ARGV.force?
      raise FormulaAlreadyInstalledError, @f
    end

    unless ignore_deps
      needed_deps = @f.recursive_deps.reject {|d| d.installed?}
      unless needed_deps.empty?
        puts "Also installing dependencies: "+needed_deps*", "
        needed_deps.each do |dep|
          FormulaInstaller.install_formula dep
        end
      end
      begin
        FormulaInstaller.check_external_deps @f
      rescue UnsatisfiedExternalDependencyError => e
        onoe e.message
        exit! 1
      end
    end
    FormulaInstaller.install_formula @f
  end

  def self.check_external_deps f
    [:ruby, :python, :perl, :jruby].each do |type|
      f.external_deps[type].each do |dep|
        unless quiet_system(*external_dep_check(dep, type))
          raise UnsatisfiedExternalDependencyError.new(dep, type)
        end
      end if f.external_deps[type]
    end
  end

  def self.external_dep_check dep, type
    case type
      when :python then %W{/usr/bin/env python -c import\ #{dep}}
      when :jruby then %W{/usr/bin/env jruby -rubygems -e require\ '#{dep}'}
      when :ruby then %W{/usr/bin/env ruby -rubygems -e require\ '#{dep}'}
      when :perl then %W{/usr/bin/env perl -e use\ #{dep}}
    end
  end

  private

  def self.install_formula f
    @attempted ||= Set.new
    raise FormulaInstallationAlreadyAttemptedError, f if @attempted.include? f
    @attempted << f

    # 1. formulae can modify ENV, so we must ensure that each
    #    installation has a pristine ENV when it starts, forking now is
    #    the easiest way to do this
    # 2. formulae have access to __END__ the only way to allow this is
    #    to make the formula script the executed script
    read, write = IO.pipe
    # I'm guessing this is not a good way to do this, but I'm no UNIX guru
    ENV['HOMEBREW_ERROR_PIPE'] = write.to_i.to_s

    fork do
      begin
        read.close
        exec '/usr/bin/nice',
             '/usr/bin/ruby',
             '-I', Pathname.new(__FILE__).dirname,
             '-rinstall',
             f.path,
             '--',
             *ARGV.options_only
      rescue Exception => e
        Marshal.dump(e, write)
        write.close
        exit! 1
      end
    end

    ignore_interrupts do # the fork will receive the interrupt and marshall it back
      write.close
      Process.wait
      data = read.read
      raise Marshal.load(data) unless data.nil? or data.empty?
      raise "Suspicious installation failure" unless $?.success?
    end
  end
end

require 'set'

## This file defines dependencies and requirements.
##
## A dependency is a formula that another formula needs to install.
## A requirement is something other than a formula that another formula
## needs to be present. This includes external language modules,
## command-line tools in the path, or any arbitrary predicate.
##
## The `depends_on` method in the formula DSL is used to declare
## dependencies and requirements.


# This class is used by `depends_on` in the formula DSL to turn dependency
# specifications into the proper kinds of dependencies and requirements.
class DependencyCollector
  # Define the languages that we can handle as external dependencies.
  LANGUAGE_MODULES = [
    :chicken, :jruby, :lua, :node, :perl, :python, :rbx, :ruby
  ].freeze

  attr_reader :deps, :external_deps

  def initialize
    @deps = Dependencies.new
    @external_deps = Set.new
  end

  def add spec
    tag = nil
    spec, tag = spec.shift if spec.is_a? Hash

    dep = parse_spec(spec, tag)
    # Some symbol specs are conditional, and resolve to nil if there is no
    # dependency needed for the current platform.
    return if dep.nil?
    # Add dep to the correct bucket
    (dep.is_a?(Requirement) ? @external_deps : @deps) << dep
  end

private

  def parse_spec spec, tag
    case spec
    when Symbol
      parse_symbol_spec(spec, tag)
    when String
      if LANGUAGE_MODULES.include? tag
        LanguageModuleDependency.new(tag, spec)
      else
        Dependency.new(spec, tag)
      end
    when Formula
      Dependency.new(spec.name, tag)
    when Dependency, Requirement
      spec
    else
      raise "Unsupported type #{spec.class} for #{spec}"
    end
  end

  def parse_symbol_spec spec, tag
    case spec
    when :autoconf, :automake, :bsdmake, :libtool
      # Xcode no longer provides autotools or some other build tools
      Dependency.new(spec.to_s) unless MacOS::Xcode.provides_autotools?
    when :x11, :libpng
      X11Dependency.new(tag)
    else
      raise "Unsupported special dependency #{spec}"
    end
  end

end


# A list of formula dependencies.
class Dependencies < Array
  def include? dependency_name
    self.any?{|d| d.name == dependency_name}
  end
end


# A dependency on another Homebrew formula.
class Dependency
  attr_reader :name, :tags

  def initialize name, tags=nil
    @name = name
    @tags = case tags
      when Array then tags.each {|s| s.to_s}
      when nil then []
      else [tags.to_s]
    end
  end

  def to_s
    @name
  end

  def ==(other_dep)
    @name == other_dep.to_s
  end

  def <=>(other_dep)
    @name <=> other_dep.to_s
  end

  def options
    @tags.select{|p|p.start_with? '--'}
  end
end


# A base class for non-formula requirements needed by formulae.
# A "fatal" requirement is one that will fail the build if it is not present.
# By default, Requirements are non-fatal.
class Requirement
  def satisfied?; false; end
  def fatal?; false; end
  def message; ""; end
  def modify_build_environment; nil end

  def eql?(other)
    other.is_a? self.class and hash == other.hash
  end

  def hash
    @message.hash
  end
end


# A dependency on a language-specific module.
class LanguageModuleDependency < Requirement
  def initialize language, module_name, import_name=nil
    @language = language
    @module_name = module_name
    @import_name = import_name || module_name
  end

  def fatal?; true; end

  def satisfied?
    quiet_system(*the_test)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: #{@module_name}
    Homebrew does not provide #{@language.to_s.capitalize} dependencies; install with:
      #{command_line} #{@module_name}
    EOS
  end

  def the_test
    case @language
      when :chicken then %W{/usr/bin/env csi -e (use #{@import_name})}
      when :jruby then %W{/usr/bin/env jruby -rubygems -e require\ '#{@import_name}'}
      when :lua then %W{/usr/bin/env luarocks show #{@import_name}}
      when :node then %W{/usr/bin/env node -e require('#{@import_name}');}
      when :perl then %W{/usr/bin/env perl -e use\ #{@import_name}}
      when :python then %W{/usr/bin/env python -c import\ #{@import_name}}
      when :ruby then %W{/usr/bin/env ruby -rubygems -e require\ '#{@import_name}'}
      when :rbx then %W{/usr/bin/env rbx -rubygems -e require\ '#{@import_name}'}
    end
  end

  def command_line
    case @language
      when :chicken then "chicken-install"
      when :jruby   then "jruby -S gem install"
      when :lua     then "luarocks install"
      when :node    then "npm install"
      when :perl    then "cpan -i"
      when :python  then "easy_install"
      when :rbx     then "rbx gem install"
      when :ruby    then "gem install"
    end
  end
end

class X11Dependency < Requirement

  def initialize min_version=nil
    @min_version = min_version
  end

  def fatal?; true; end

  def satisfied?
    MacOS.x11_installed? and (@min_version == nil or @min_version <= MacOS.xquartz_version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Please install the latest version of XQuartz:
      https://xquartz.macosforge.org
    EOS
  end

  def modify_build_environment
    ENV.x11
  end

end

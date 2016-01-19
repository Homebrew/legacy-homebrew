require "requirement"

class LanguageModuleRequirement < Requirement
  fatal true

  def initialize(language, module_name, import_name = nil)
    @language = language
    @module_name = module_name
    @import_name = import_name || module_name
    super([language, module_name, import_name])
  end

  satisfy(:build_env => false) { quiet_system(*the_test) }

  def message; <<-EOS.undent
    Unsatisfied dependency: #{@module_name}
    Homebrew does not provide #{@language.to_s.capitalize} dependencies; install with:
      #{command_line} #{@module_name}
    EOS
  end

  def the_test
    case @language
    when :lua then %W[/usr/bin/env luarocks-5.2 show #{@import_name}]
    when :lua51 then %W[/usr/bin/env luarocks-5.1 show #{@import_name}]
    when :perl then %W[/usr/bin/env perl -e use\ #{@import_name}]
    when :python then %W[/usr/bin/env python -c import\ #{@import_name}]
    when :python3 then %W[/usr/bin/env python3 -c import\ #{@import_name}]
    when :ruby then %W[/usr/bin/env ruby -rubygems -e require\ '#{@import_name}']
    end
  end

  def command_line
    case @language
    when :lua     then "luarocks-5.2 install"
    when :lua51   then "luarocks-5.1 install"
    when :perl    then "cpan -i"
    when :python  then "pip install"
    when :python3 then "pip3 install"
    when :ruby    then "gem install"
    end
  end
end

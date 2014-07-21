require 'requirement'

class LanguageModuleDependency < Requirement
  fatal true

  def initialize language, module_name, import_name=nil
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
      when :chicken then %W{/usr/bin/env csi -e (use\ #{@import_name})}
      when :jruby then %W{/usr/bin/env jruby -rubygems -e require\ '#{@import_name}'}
      when :lua then %W{/usr/bin/env luarocks show #{@import_name}}
      when :node then %W{/usr/bin/env node -e require('#{@import_name}');}
      when :ocaml then %W{/usr/bin/env opam list #{@import_name}}
      when :perl then %W{/usr/bin/env perl -e use\ #{@import_name}}
      when :python then %W{/usr/bin/env python -c import\ #{@import_name}}
      when :python3 then %W{/usr/bin/env python3 -c import\ #{@import_name}}
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
      when :ocaml   then "opam install"
      when :perl    then "cpan -i"
      when :python  then "pip install"
      when :python3 then "pip3 install"
      when :rbx     then "rbx gem install"
      when :ruby    then "gem install"
    end
  end
end

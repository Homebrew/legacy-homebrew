require 'superenv'
require 'formula'

module Homebrew extend self
  def sh
    if superenv?
      ENV.x11 = true
      ENV.deps = Formula.installed.select{|f| f.keg_only? and f.opt_prefix.directory? }.map(&:name)
    end
    ENV.setup_build_environment
    ENV['PS1'] = 'brew \[\033[1;32m\]\w\[\033[0m\]$ '
    ENV['VERBOSE'] = '1'
    ENV['HOMEBREW_LOG'] = '1'
    puts <<-EOS.undent_________________________________________________________72
         Your shell has been configured to use Homebrew's build environment:
         this should help you build stuff. Notably though, the system versions of
         gem and pip will ignore our configuration and insist on using the
         environment they were built under (mostly). Sadly, scons will also
         ignore our configuration.
         All toolchain use will be logged to: ~/Library/Homebrew/Logs/cc.log
         When done, type `exit'.
         EOS
    exec ENV['SHELL']
  end
end

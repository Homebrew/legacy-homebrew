require 'formula'

class Chruby < Formula

  homepage 'https://github.com/postmodern/chruby#readme'
  url 'https://github.com/postmodern/chruby/archive/v0.2.5.tar.gz'
  sha1 '0b4819754f320ea32a66aaae91a4e426dcc264fc'

  head 'https://github.com/postmodern/chruby.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For a system wide install, add the following to /etc/profile.d/chruby.sh.

      #!/bin/sh
      source #{HOMEBREW_PREFIX}/opt/chruby/share/chruby/chruby.sh
      RUBIES=(/opt/rubies/*)

    For a local install, add the following to ~/.bashrc or ~/.zshrc.

      #!/bin/sh
      source #{HOMEBREW_PREFIX}/opt/chruby/share/chruby/chruby.sh
      RUBIES=(~/.rubies/*)

    To use existing Rubies installed by RVM, rbenv or rbfu, set RUBIES to
    the following:

      RVM:   RUBIES=(~/.rvm/rubies/*)
      rbenv: RUBIES=(~/.rbenv/versions/*)
      rbfu:  RUBIES=('~/.rbfu/rubies/*)

    EOS
  end
end

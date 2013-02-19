require 'formula'

class Chruby < Formula
  homepage 'https://github.com/postmodern/chruby#readme'
  url 'https://github.com/postmodern/chruby/archive/v0.3.3.tar.gz'
  sha1 '3167afdb679f7c9d486410ad98578658f4956d24'

  head 'https://github.com/postmodern/chruby.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to the /etc/profile.d/chruby.sh, ~/.bash_profile or
    ~/.zprofile file:

      source #{HOMEBREW_PREFIX}/opt/chruby/share/chruby/chruby.sh

    By default chruby will search for Rubies installed into /opt/rubies/ or
    ~/.rubies/. For non-standard installation locations, simply set the RUBIES
    variable:

      RUBIES=(
        /opt/jruby-1.7.0
        $HOME/src/rubinius
      )

    If you are migrating from another Ruby manager, set `RUBIES` accordingly:

      RVM:   RUBIES=(~/.rvm/rubies/*)
      rbenv: RUBIES=(~/.rbenv/versions/*)
      rbfu:  RUBIES=('~/.rbfu/rubies/*)

    To enable auto-switching of Rubies specified by .ruby-version files:

      source #{HOMEBREW_PREFIX}/opt/chruby/share/chruby/auto.sh
    EOS
  end
end

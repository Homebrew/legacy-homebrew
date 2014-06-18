require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  head 'https://github.com/playframework/playframework.git'
  url 'http://downloads.typesafe.com/play/2.2.3/play-2.2.3.zip'
  sha1 '16beea55568a6b5876439ffbf908ba6448c5c713'

  conflicts_with 'sox', :because => 'both install `play` binaries'

  def install
    system "./framework/build", "publish-local" if build.head?
    rm_rf Dir["**/*.bat"]
    libexec.install Dir['*']
    bin.install_symlink libexec/'play'
  end

  def caveats; <<-EOS.undent
    In Play 2.3 the play command has become the activator command. Play has been updated to use Activator.

    This formula only installs Play version 2.2.3, if you would like to install the newest versions run:
    brew remove play
    brew install typesafe-activator

    You can read more about this change at:
    http://www.playframework.com/documentation/2.3.x/Migration23
    and
    http://www.playframework.com/documentation/2.3.x/Highlights23
  EOS
  end
end

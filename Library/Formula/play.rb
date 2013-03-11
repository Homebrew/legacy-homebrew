require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://downloads.typesafe.com/releases/play-1.2.5.zip'
  md5 '31d204bb105f67c5e418fad073e818a4'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.install_symlink libexec+'play'
  end
end

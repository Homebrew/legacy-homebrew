require 'formula'

class Play2 < Formula
  homepage 'http://www.playframework.org/'
  url 'http://download.playframework.org/releases/play-2.0-RC4.zip'
  md5 '98a9bbe198ca75146dfac813af5cfdbd'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.install_symlink libexec+'play'
  end
end

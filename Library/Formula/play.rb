require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.2.zip'
  homepage 'http://www.playframework.org/'
  md5 'dbe7321a7bef3a00b6ab67ededf865eb'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end
end

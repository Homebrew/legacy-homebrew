require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://downloads.typesafe.com/play/1.2.6/play-1.2.6.zip'
  md5 'f4c7efe8eff63929f0f248d090e9afac'

  def install
    rm_rf 'python' # we don't need the bundled Python for windows
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.install_symlink libexec+'play1'
  end
end
require 'formula'

class Sslh < Formula
  homepage 'http://www.rutschle.net/tech/sslh.shtml'
  url 'https://github.com/yrutschle/sslh/archive/v1.15.tar.gz'
  sha1 'f764541b3dcc1a8ece7e3aa9e46c9f1a3c23114a'

  depends_on 'libconfig'

  def install
    ENV.j1
    system 'make'
    bin.install 'sslh-fork', 'sslh-select'
    ln_s bin/'sslh-fork', bin/'sslh'
    man8.install 'sslh.8.gz'
  end
end

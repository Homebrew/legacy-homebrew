require 'formula'

class Sslh < Formula
  homepage 'http://www.rutschle.net/tech/sslh.shtml'
  url 'https://github.com/yrutschle/sslh/archive/v1.16.tar.gz'
  sha1 '7139672fa8e2fd1befde2e1f9a73ce2ade04920c'

  depends_on 'libconfig'

  def install
    ENV.j1
    system 'make'
    bin.install 'sslh-fork', 'sslh-select'
    bin.install_symlink 'sslh-fork' => 'sslh'
    man8.install 'sslh.8.gz'
  end
end

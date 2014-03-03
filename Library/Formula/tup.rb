require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.7.1.tar.gz'
  sha1 'a0ce259ce74321d2c103e63dffbf9703b7392e16'
  head 'https://github.com/gittup/tup.git'

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'

  def install
    ENV['TUP_LABEL'] = version
    system "./build.sh"
    bin.install 'build/tup'
    man1.install 'tup.1'
  end

  test do
    system "#{bin}/tup", "-v"
  end
end

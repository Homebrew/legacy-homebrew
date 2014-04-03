require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.7.2.tar.gz'
  sha1 'c0b14a9b7a59c6295ed7339883b21d0f1a8163b3'
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

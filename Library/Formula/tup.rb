require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  head 'https://github.com/gittup/tup.git'
  url 'https://github.com/gittup/tup.git', :tag => 'v0.6'
  version '0.6'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    ENV['TUP_LABEL'] = version
    system "./build.sh"
    bin.install 'build/tup'
    man1.install 'tup.1'
  end

  def test
    system "tup -v"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before using 'tup' build tool.
    EOS
  end
end

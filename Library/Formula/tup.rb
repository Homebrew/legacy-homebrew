require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/tarball/v0.6'
  md5 '335ab8f5348955b4bfe2c8e7b22df4c7'
  head 'https://github.com/gittup/tup.git'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    ENV['TUP_LABEL'] = version
    system "./build.sh"
    bin.install 'build/tup'
    man1.install 'tup.1'
  end

  def test
    system "#{bin}/tup", "-v"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info fuse4x-kext`
    before using 'tup' build tool.
    EOS
  end
end

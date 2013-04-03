require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.6.tar.gz'
  sha1 '59d5bec8dcbdd407ed654ad25ae05d42a4213a2c'
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

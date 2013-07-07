require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  url 'https://github.com/gittup/tup/archive/v0.6.5.tar.gz'
  sha1 '0df86d8b607b34aee64cbadf1e6e0d090886f077'
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

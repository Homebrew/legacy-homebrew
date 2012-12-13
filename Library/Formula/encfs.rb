require 'formula'

class Encfs < Formula
  homepage 'http://www.arg0.net/encfs'
  url 'http://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  sha1 '3d824ba188dbaabdc9e36621afb72c651e6e2945'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'fuse4x'

  def install
    inreplace "configure", "-lfuse", "-lfuse4x"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info fuse4x-kext`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end

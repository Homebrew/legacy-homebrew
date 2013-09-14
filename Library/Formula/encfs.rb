require 'formula'

class OSXFuseRequirement < Requirement
  fatal true
  satisfy { Pathname('/usr/local/include/osxfuse').exist? }

  def message; <<-EOS.undent
    To build this formula with --without-fuse4x, you must first
    install OSXFUSE. Since there is no formula for OSXFUSE yet,
    you should download the OSXFUSE package here:

      http://osxfuse.github.io
    EOS
  end
end

class Encfs < Formula
  homepage 'http://www.arg0.net/encfs'
  url 'http://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  sha1 '3d824ba188dbaabdc9e36621afb72c651e6e2945'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'
  option 'without-fuse4x', 'Build without fuse4x support (requires OSXFUSE)'
  depends_on 'fuse4x' => :recommended
  depends_on OSXFuseRequirement if build.without? 'fuse4x'

  def install
    if build.without? 'fuse4x'
      ENV['CPPFLAGS'] = '-I/usr/local/include/osxfuse'
      libfuse = 'osxfuse'
    else
      libfuse = 'fuse4x'
    end
    inreplace "configure", "-lfuse", "-l#{libfuse}"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Unless you build using --without-fuse4x, make sure
    to follow the directions given by `brew info fuse4x-kext`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end

require 'formula'

class Encfs < Formula
  url 'http://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  homepage 'http://www.arg0.net/encfs'
  md5 'ac90cc10b2e9fc7e72765de88321d617'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'fuse4x' if ARGV.include? "--fuse4x"

  def options
    [
      ["--fuse4x", "Use Fuse4X (http://fuse4x.org/) instead of MacFUSE"],
    ]
  end

  def caveats
    s = "For build options see:\n  brew options encfs\n\n"

    if ARGV.include? "--fuse4x"
      s += <<-EOS.undent
        Make sure to follow the directions given by `brew info fuse4x-kext`
        before trying to use a FUSE-based filesystem.
      EOS
    else
      s += <<-EOS.undent
        encfs requires MacFUSE 2.6 or later to be installed.
        You can find MacFUSE at:
          http://code.google.com/p/macfuse/
      EOS
    end
  end

  def install
    if ARGV.include? "--fuse4x"
       inreplace "configure", "-lfuse", "-lfuse4x"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end

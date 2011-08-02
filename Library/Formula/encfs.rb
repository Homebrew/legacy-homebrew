require 'formula'

class Encfs < Formula
  url 'http://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  homepage 'http://www.arg0.net/encfs'
  md5 'ac90cc10b2e9fc7e72765de88321d617'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'

  def caveats
    <<-EOS.undent
      encfs requires MacFUSE 2.6 or later to be installed.
      You can find MacFUSE at:
        http://code.google.com/p/macfuse/
    EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end

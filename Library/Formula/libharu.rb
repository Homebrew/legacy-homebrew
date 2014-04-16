require 'formula'

class Libharu < Formula
  homepage 'http://www.libharu.org'
  url 'http://libharu.org/files/libharu-2.2.1.tar.bz2'
  sha1 'bfea7d9df3fb6a112340d0d54731f62f53b26d2f'
  revision 1

  depends_on 'libpng'

  # Fixes compilation against LibPNG 1.5. Can be removed on next release.
  # Based on a commit in the LibHaru repository which does not apply cleanly
  # due to a missing CHANGES file:
  # https://github.com/tony2001/libharu/commit/e5bf8b0.patch
  patch do
    url "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/libharu/files/libharu-2.2.1-libpng-1.5.patch?revision=1.1"
    sha1 "463641d4570d59d632c1878597253db962129599"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}"
    system "make install"
  end
end

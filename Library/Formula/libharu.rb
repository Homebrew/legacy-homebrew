require 'formula'

class Libharu < Formula
  homepage 'http://www.libharu.org'
  url 'http://libharu.org/files/libharu-2.2.1.tar.bz2'
  md5 '4febd7e677b1c5d54db59a608b84e79f'

  depends_on :libpng

  def patches
    # Fixes compilation against LibPNG 1.5. Can be removed on next release.
    # Based on a commit in the LibHaru repository which does not apply cleanly
    # due to a missing CHANGES file:
    #
    #     https://github.com/tony2001/libharu/commit/e5bf8b0.patch
    "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/libharu/files/libharu-2.2.1-libpng-1.5.patch?revision=1.1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # libpng doesn't get picked up
                          "--with-png=#{MacOS::XQuartz.prefix}"
    system "make install"
  end
end

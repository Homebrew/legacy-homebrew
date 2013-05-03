require 'formula'

class Libharu < Formula
  homepage 'http://www.libharu.org'
  url 'http://libharu.org/files/libharu-2.2.1.tar.bz2'
  sha1 'bfea7d9df3fb6a112340d0d54731f62f53b26d2f'

  depends_on :libpng

  def patches
    # Fixes compilation against LibPNG 1.5. Can be removed on next release.
    # Based on a commit in the LibHaru repository which does not apply cleanly
    # due to a missing CHANGES file:
    #
    #     https://github.com/tony2001/libharu/commit/e5bf8b0.patch
    "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/libharu/files/libharu-2.2.1-libpng-1.5.patch?revision=1.1"
  end

  def png_prefix
    MacOS::X11.installed? ? MacOS::X11.prefix : HOMEBREW_PREFIX/:opt/:libpng
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # libpng doesn't get picked up
                          "--with-png=#{png_prefix}"
    system "make install"
  end
end

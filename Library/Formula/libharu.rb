require 'formula'

class Libharu < Formula
  homepage 'http://www.libharu.org'
  url 'http://libharu.org/files/libharu-2.2.1.tar.bz2'
  sha1 'bfea7d9df3fb6a112340d0d54731f62f53b26d2f'
  revision 1

  bottle do
    cellar :any
    sha1 "38e83c295e83e290a5df03f4932b07ca8bc18707" => :yosemite
    sha1 "22384f48ee22ae06ccf0636a86c61fa27fd26797" => :mavericks
    sha1 "0a20c683544726d870f53c005f79a730b1effffe" => :mountain_lion
  end

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

class Ogmtools < Formula
  desc "OGG media streams manipulation tools"
  homepage "https://www.bunkus.org/videotools/ogmtools/"
  url "https://www.bunkus.org/videotools/ogmtools/ogmtools-1.5.tar.bz2"
  sha256 "c8d61d1dbceb981dc7399c1a85e43b509fd3d071fb8d3ca89ea9385e6e40fdea"

  bottle do
    cellar :any
    sha256 "8e0ceae59b3a69647511dff89566a734d25a96a764893c7599ee1ece73890db5" => :el_capitan
    sha256 "3a43fec619944cd6fa8e57bd067477ef63997919e11174ddafb160c47b28fd5d" => :yosemite
    sha256 "9dc3df5391b2203a0da69ad5be638daa066f9bfc2655bf4d553837aa90f7f4d1" => :mavericks
  end

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libdvdread" => :optional

  # Borrow patch from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/e4957439/ogmtools/common.h.diff"
    sha256 "2dd18dea6de0d2820221bde8dfea163101d0037196cb2e94cd910808d10119c0"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  # Borrow warning from MacPorts
  def caveats; <<-EOS.undent
    Ogmtools has not been updated since 2004 and is no longer being developed,
    maintained or supported. There are several issues, especially on 64-bit
    architectures, which the author will not fix or accept patches for.
    Keep this in mind when deciding whether to use this software.
    EOS
  end
end

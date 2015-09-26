class Libdv < Formula
  desc "Codec for DV video encoding format"
  homepage "http://libdv.sourceforge.net"
  url "https://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz"
  sha256 "a305734033a9c25541a59e8dd1c254409953269ea7c710c39e540bd8853389ba"

  bottle do
    cellar :any
    revision 1
    sha256 "0624e82748111d0a8a050a802ec4251c443127c39c93b3b2469a00816a602040" => :el_capitan
    sha1 "52e46dd26669bd9b226bfb774eac76a4f3cab442" => :yosemite
    sha1 "035268b04e85f298530c3791b272e124fc62fa89" => :mavericks
    sha1 "cc99e4e39bd24188d03b841eb24a39d31574b83a" => :mountain_lion
  end

  depends_on "popt"

  def install
    # This fixes an undefined symbol error on compile.
    # See the port file for libdv. http://libdv.darwinports.com/
    # This flag is the preferred method over what macports uses.
    # See the apple docs: http://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-asm",
                          "--disable-sdltest"
    system "make", "install"
  end
end

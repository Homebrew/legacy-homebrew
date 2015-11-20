class Libdv < Formula
  desc "Codec for DV video encoding format"
  homepage "http://libdv.sourceforge.net"
  url "https://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz"
  sha256 "a305734033a9c25541a59e8dd1c254409953269ea7c710c39e540bd8853389ba"

  bottle do
    cellar :any
    revision 1
    sha256 "0624e82748111d0a8a050a802ec4251c443127c39c93b3b2469a00816a602040" => :el_capitan
    sha256 "49262f766082fa4c9a509236bdaf5eec8746a8c4b9724fc83521bfc5725660c7" => :yosemite
    sha256 "830002340f10dae43ba81d370bfbcd92a40f8b9330ed03fcb627b70983069a7b" => :mavericks
    sha256 "9f10897bacdbeee6f6480c2409764f418e8d0d9230d521e3ee1dd9c8a8926072" => :mountain_lion
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

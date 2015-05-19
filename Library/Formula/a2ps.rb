class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "http://www.gnu.org/software/a2ps/"
  url "http://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz"
  mirror "http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz"
  sha1 "365abbbe4b7128bf70dad16d06e23c5701874852"

  bottle do
    sha1 "c33f22a088a0b1ed22efff0165722e87495a4bd0" => :yosemite
    sha1 "7ae09c9835ebb1913b97cf5f06bab42a0d1f33a6" => :mavericks
    sha1 "3d27c530648004119cbf63edf1549357d5775572" => :mountain_lion
  end

  # Software was last updated in 2007, so take MacPorts patches to get
  # it working on 10.6. See:
  # https://svn.macports.org/ticket/20867
  # http://trac.macports.org/ticket/18255
  patch :p0 do
    url "https://trac.macports.org/export/56498/trunk/dports/print/a2ps/files/patch-contrib_sample_Makefile.in"
    sha1 "9b385295c2377e5362d62991e84d138d1713aabd"
  end

  patch :p0 do
    url "https://trac.macports.org/export/56498/trunk/dports/print/a2ps/files/patch-lib__xstrrpl.c"
    sha1 "106e13409a96d68df0fdea0b89790ddfc0893f8b"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system "#{bin}/a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end

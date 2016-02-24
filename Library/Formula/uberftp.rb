class Uberftp < Formula
  desc "Interactive GridFTP client"
  homepage "http://dims.ncsa.illinois.edu/set/uberftp/"
  url "https://github.com/JasonAlt/UberFTP/archive/Version_2_8.tar.gz"
  sha256 "8a397d6ef02bb714bb0cbdb259819fc2311f5d36231783cd520d606c97759c2a"

  bottle do
    cellar :any
    sha256 "e8dce3fad5462c096d9e1c4e605280679f9a79b6b9204401fb10d3449807d2d9" => :el_capitan
    sha256 "84ab25a3cae1ac0d4aeb2b967b151b396301eb1f7877bb6225ed202847a35cff" => :yosemite
    sha256 "9c7f1cbb83c268b00a137e608497bafe066ac41a034c256ca55075d1eeb72cfe" => :mavericks
  end

  depends_on "globus-toolkit"

  def install
    globus = Formula["globus-toolkit"].opt_prefix

   # patch needed since location changed with globus-toolkit versions>=6.0,
   # patch to upstream is not yet merged
   # (located at https://github.com/JasonAlt/UberFTP/pull/8)
   # but solves not whole problem (needs aditional patch)
    inreplace "configure", "globus_location/include/globus/gcc64dbg", "globus_location/libexec/include"
    inreplace "configure", "globus_location/lib64", "globus_location/libexec/lib"

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus=#{globus}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end

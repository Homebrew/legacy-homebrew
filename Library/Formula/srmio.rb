class Srmio < Formula
  desc "C library to access the PowerControl of a SRM bike power meter"
  homepage "http://www.zuto.de/project/srmio/"
  url "http://www.zuto.de/project/files/srmio/srmio-0.1.1~git1.tar.gz"
  sha256 "00b3772202034aaada94f1f1c79a1072fac1f69d10ef0afcb751cce74e5ccd31"
  version "0.1.1~git1"

  head do
    url "https://github.com/rclasen/srmio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "chmod u+x genautomake.sh"
      system "./genautomake.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/srmcmd", "--version"
  end
end

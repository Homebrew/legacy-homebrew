class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.4.8.tar.gz"
  mirror "https://distfiles.macports.org/libsmi/libsmi-0.4.8.tar.gz"
  sha256 "f048a5270f41bc88b0c3b0a8fe70ca4d716a46b531a0ecaaa87c462f49d74849"

  bottle do
    revision 1
    sha256 "27cffaf7b38a36a1da50661a3a7a243fd9aaecaa73e4a91a462155a553a17f52" => :el_capitan
    sha1 "926dcdef0a96a52898ef1848c621bb261ea96330" => :yosemite
    sha1 "545b6b13369663d040e377380a1363a6fe79527a" => :mavericks
    sha1 "a51083176c16132820ed4cdd2a68666baba11ff1" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/smidiff -V")
  end
end

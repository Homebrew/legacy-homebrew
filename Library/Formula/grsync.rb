class Grsync < Formula
  desc "GUI for rsync"
  homepage "http://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.5.tar.gz"
  sha256 "4f1443154f7c85ca7b0e93d5fea438e2709776005e7cfc97da89f4899b1c12e5"
  revision 1

  bottle do
    revision 1
    sha256 "ea12e9e95d04f06c892915a476919f991af95b39e5653fae76d4026cb50906a1" => :el_capitan
    sha256 "39e1387923c5a9f9d591bb5e8f6d3ed9fa1dedc94c521285e7948a272597549e" => :yosemite
    sha256 "6ec80e0362bff0bac9976c1ca2088d5152273e926b1a6cb3a331e8435c8d4c0c" => :mavericks
    sha256 "b95620a523c2bd02260a75ddfcf97dc428629ac4314ab0d12b763376eed357cd" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert (bin/"grsync").exist?
  end
end

class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "http://gabedit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit248/GabeditSrc248.tar.gz"
  version "2.4.8"
  sha256 "38d6437a18280387b46fd136f2201a73b33e45abde13fa802c64806b6b64e4d3"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  def install
    args = []
    args << "OMPLIB=" << "OMPCFLAGS=" if ENV.compiler == :clang
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert (bin/"gabedit").exist?
  end
end

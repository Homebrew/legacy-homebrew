class Jerasure < Formula
  desc "Library in C that supports erasure coding in storage applications"
  homepage "http://jerasure.org/"
  url "http://lab.jerasure.org/jerasure/jerasure/repository/archive.tar.gz?ref=v2.0"
  sha256 "61b2fbb25affeddc2d94d6f67778098597b14ff5440f39d8fba3dbdbaa6739b6"

  bottle do
    cellar :any
    sha256 "f9b3b18ac272a9a3c96d4fdef5b78c3dca4719b4493b7c1e5171bfa7e5d1731b" => :el_capitan
    sha256 "4bbf04ae52e868a4b356eb242bb98ede4c2efb744dd32c979b7658cf64a8dfb6" => :yosemite
    sha256 "8f9b0282b6db808f94a915b83e937ae2e1413a2e5b49e72f2196235f0cff2962" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gf-complete"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jerasure_01", "2", "5", "3"
  end
end

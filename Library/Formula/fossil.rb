class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  head "https://www.fossil-scm.org/", :using => :fossil
  url "https://www.fossil-scm.org/download/fossil-src-1.33.tar.gz"
  sha256 "6295c48289456f09e86099988058a12148dbe0051b72d413b4dff7216d6a7f3e"

  bottle do
    cellar :any
    sha256 "93c2998a284d05cdde365f968aacfcb05e6ce746a90e767de85c4e8a98084b4f" => :yosemite
    sha256 "9e1a6a19e95dfd0a92eaf465a76326ecef672c67a4ba7854b3baa363b96f9dc9" => :mavericks
    sha256 "3cf1b9a1e660e36e85d24b423c03d8742d515799060a15af3095ec5a3890894e" => :mountain_lion
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"

  def install
    args = []
    args << "--json" if build.with? "json"
    args << "--with-tcl" if build.with? "tcl"

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end

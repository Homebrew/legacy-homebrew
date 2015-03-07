class Fossil < Formula
  homepage "https://www.fossil-scm.org/"
  head "https://www.fossil-scm.org/", :using => :fossil
  url "https://www.fossil-scm.org/download/fossil-src-20150223162734.tar.gz"
  sha256 "c00f9e1487530adb921df730baf57e1aa23767a0afb60b865e5842bb50782942"
  version "1.31"

  bottle do
    cellar :any
    sha256 "0008984514cf0956aca9371492c8ff779ab224378d620f9a97e204516b899f0c" => :yosemite
    sha256 "ac24fa102938c7f533e9d9a28c1d622fafb2ddc54e3e2a28d2fe630a95fa9a3b" => :mavericks
    sha256 "0e136626581d82192245d1373aeaeaa5a4a71369f08ecf8d008713e7ad5ae529" => :mountain_lion
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

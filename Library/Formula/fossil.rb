class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/download/fossil-src-1.33.tar.gz"
  sha256 "6295c48289456f09e86099988058a12148dbe0051b72d413b4dff7216d6a7f3e"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    revision 1
    sha256 "39418c8caef8df38e4366e25fb5be3fe26220e379235e68961fb727fca8d0ca9" => :yosemite
    sha256 "1cb30f778d37395a1128af80aa961e8c7759f15e70a202411cb8c67dfca60668" => :mavericks
    sha256 "e64bead6791751dcd19625189f491e494f2a574247b9e581cabdfca6f5a02225" => :mountain_lion
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = []
    args << "--json" if build.with? "json"

    if MacOS::CLT.installed? && build.with?("tcl")
      args << "--with-tcl"
    else
      args << "--with-tcl-stubs"
    end

    if build.with? "osxfuse"
      ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include/osxfuse"
    else
      args << "--disable-fusefs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end

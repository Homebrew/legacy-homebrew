class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/download/fossil-src-1.34.tar.gz"
  sha256 "53a6b83e878feced9ac7705f87e5b6ea82727314e3e19202ae1c46c7e4dba49f"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    revision 1
    sha256 "b7ef31ca95673d3c2056c4a8f7e8fd117f362a4d402ab2573ddccb46edcfe45d" => :el_capitan
    sha256 "39418c8caef8df38e4366e25fb5be3fe26220e379235e68961fb727fca8d0ca9" => :yosemite
    sha256 "1cb30f778d37395a1128af80aa961e8c7759f15e70a202411cb8c67dfca60668" => :mavericks
    sha256 "e64bead6791751dcd19625189f491e494f2a574247b9e581cabdfca6f5a02225" => :mountain_lion
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # http://comments.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1"
    ]
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

class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/download/fossil-src-1.34.tar.gz"
  sha256 "53a6b83e878feced9ac7705f87e5b6ea82727314e3e19202ae1c46c7e4dba49f"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "c63a8f0c159ca20bfd2808c1bd56d2a0e599fa316c56e731285bb2adc68389b2" => :el_capitan
    sha256 "032e30a35f52aa80a409ae62194b412132bd2fb16399e64593594d3e60f77388" => :yosemite
    sha256 "7ed7555f4240cdc6366e40810c57285e2402f7637483a69befeec52dd2693d65" => :mavericks
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

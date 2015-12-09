class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "http://ftpmirror.gnu.org/gdbm/gdbm-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.11.tar.gz"
  sha256 "8d912f44f05d0b15a4a5d96a76f852e905d051bb88022fcdfd98b43be093e3c3"

  bottle do
    cellar :any
    revision 2
    sha256 "59868f18b7b88e9c47cfd802435618881ac8858408d3ebfb009803db0c415a32" => :el_capitan
    sha256 "1ad0aacc00881d05f8f894d8d117e4e0b8b5f5afc15a37a3f7c735c040ef0c5a" => :yosemite
    sha256 "440dc9069280d474af52847f18dbcdbb10813a237522f650fcbe6c63dae784dc" => :mavericks
    sha256 "bf77827fb3e51ed8691ed357014343f72587cbd2dd7248922ac8f70117e4c5e8" => :mountain_lion
  end

  option :universal
  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert File.exist?("test")
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end

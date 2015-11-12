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
    sha1 "ae6850dce748a51b1d4270ae201dc50eb1a05d24" => :yosemite
    sha1 "b6e5a8d874b0a28cf9405e625c0d99799ad78c68" => :mavericks
    sha1 "a7786dbb967f0b42d6a25b6e25582270435de6c0" => :mountain_lion
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

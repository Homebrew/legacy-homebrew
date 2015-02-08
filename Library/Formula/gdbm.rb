class Gdbm < Formula
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftpmirror.gnu.org/gdbm/gdbm-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.11.tar.gz"
  sha1 "ce433d0f192c21d41089458ca5c8294efe9806b4"

  bottle do
    cellar :any
    revision 1
    sha1 "51d9c80b023a12571843e10984aa026c55d487f9" => :yosemite
    sha1 "73f8a00866a510eb8b6aac08ab0462aec6aa56ff" => :mavericks
    sha1 "11e8b6c44f03db030339aaaf05187b208d67d168" => :mountain_lion
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

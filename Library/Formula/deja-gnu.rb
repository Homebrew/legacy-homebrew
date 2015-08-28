class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.3.tar.gz"
  sha256 "099b8e364ca1d6248f8e1d32168c4b12677abff4253bbbb4a8ac8cdd321e3f19"

  bottle do
    cellar :any
    sha256 "a77ab52f9f7db8a6862122e8b675229b544c6b02b5a8e7b6016af825b502c4a5" => :yosemite
    sha256 "eb5ee1df1704093d1332728ef12e497ae824a78895e62eacabe60a4442ff8ddd" => :mavericks
    sha256 "6c93bd2a93a51f94d1b980fe0b9172a1bf91107777b309fbbf9342a4d085c498" => :mountain_lion
  end

  head do
    url "http://git.savannah.gnu.org/r/dejagnu.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.j1 # Or fails on Mac Pro
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/runtest"
  end
end

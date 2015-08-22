class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.3.tar.gz"
  sha256 "099b8e364ca1d6248f8e1d32168c4b12677abff4253bbbb4a8ac8cdd321e3f19"

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

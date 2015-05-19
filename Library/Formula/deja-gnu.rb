class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.2.tar.gz"
  sha1 "20a6c64e8165c1e6dbbe3638c4f737859942c94d"

  head "http://git.sv.gnu.org/r/dejagnu.git"

  def install
    ENV.j1 # Or fails on Mac Pro
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

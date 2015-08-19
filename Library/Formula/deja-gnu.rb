class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.2.tar.gz"
  sha256 "90b5f3ccd7a4a2def5099a57ae99c7b8f587eb170c3c8df874c5934e1e5d33a2"

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

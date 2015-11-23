class Pipemeter < Formula
  desc "Shows speed of data moving from input to output"
  homepage "https://launchpad.net/pipemeter"
  url "https://launchpad.net/pipemeter/trunk/1.1.3/+download/pipemeter-1.1.3.tar.gz"
  sha256 "1ff952cb2127476ca9879f4b28fb92d6dabb0cc02db41f657025f7782fd50aaf"

  bottle do
    cellar :any
    sha256 "cee0b494c5f7647d0c597e90dbc8be2c7b759d53a12cd87f89f9620b9260c3ac" => :yosemite
    sha256 "a1bd1a5466eb44aeeba7ab2563f3bd34978d248deec50964624f985f066fe2bf" => :mavericks
    sha256 "e09a0f2e40995592ab93cff23d12cd58b3ef911acc598e4fab2a5211058f3521" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # Fix the man1 directory location
    inreplace "Makefile", "$(PREFIX)/man/man1", man1

    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    assert_match "3.00B", pipe_output("pipemeter -r 2>&1 >/dev/null", "foo", 0)
  end
end

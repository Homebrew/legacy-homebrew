class Pipemeter < Formula
  homepage "https://launchpad.net/pipemeter"
  url "https://launchpad.net/pipemeter/trunk/1.1.3/+download/pipemeter-1.1.3.tar.gz"
  sha256 "1ff952cb2127476ca9879f4b28fb92d6dabb0cc02db41f657025f7782fd50aaf"

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

class DovecotPigeonhole < Formula
  desc "Sieve addon for Dovecot mailserver"
  homepage "http://pigeonhole.dovecot.org/"
  url "http://pigeonhole.dovecot.org/releases/2.2/dovecot-2.2-pigeonhole-0.4.8.tar.gz"
  sha256 "d73c1c5a11cdfdcb58304a1c1272cce6c8e1868e3f61d393b3b8a725f3bf665b"

  option "with-unfinished-features", "Build unfinished new features/extensions"

  depends_on "dovecot"

  def install
    args = ["--disable-dependency-tracking",
            "--with-dovecot=#{HOMEBREW_PREFIX}/lib/dovecot",
            "--prefix=#{prefix}",]

    if build.with? "unfinished-features"
      args << "--with-unfinished-features"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end

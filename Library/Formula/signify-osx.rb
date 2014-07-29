require "formula"

class SignifyOsx < Formula
  homepage "http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.1.tar.gz"
  sha256 "e62649b908b2ae3b8940a452e95b034772cd2856603a196d4a50d78701ed6478"
  head "https://github.com/jpouellet/signify-osx.git"

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "pubkey", "-s", "seckey"
  end
end

require "formula"

class SignifyOsx < Formula
  homepage "http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.1.tar.gz"
  sha256 "e62649b908b2ae3b8940a452e95b034772cd2856603a196d4a50d78701ed6478"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any
    sha1 "b327798f0dabb99de3ab4a57dffb9106ab98278b" => :mavericks
    sha1 "626173becda370cf363c5e1f891c5132be4e22f9" => :mountain_lion
    sha1 "271dffbae2ffbec4720250934caab7badadbace2" => :lion
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "pubkey", "-s", "seckey"
  end
end

require 'formula'

class Whois < Formula
  homepage 'http://packages.debian.org/sid/whois'
  url 'http://ftp.debian.org/debian/pool/main/w/whois/whois_5.0.17.tar.xz'
  sha256 'b20bc0e80ea6594d82e004ec02ceac0ce663bc211097c221c550080dca2c0da7'

  depends_on 'xz' => :build

  def install
    system "make whois"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end
end

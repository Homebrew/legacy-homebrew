class Dircproxy < Formula
  desc "IRC proxy server (AKA 'bouncer')"
  homepage "https://code.google.com/p/dircproxy/"
  url "https://dircproxy.googlecode.com/files/dircproxy-1.2.0-RC1.tar.gz"
  sha256 "40ad50ffd13681114f995519dc3f65f48cb5eac41e780ad14ce8ffd49463757f"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ssl"
    system "make", "install"
  end
end

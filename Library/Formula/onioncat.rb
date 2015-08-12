class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/current/onioncat-0.2.2.r569.tar.gz"
  version "0.2.2.r569"
  sha256 "377777de0d3c731fd2253db02b25562a2ed17e82901d0569308754215223f0bb"

  bottle do
    sha256 "1adbca52faa26a57fd6e211b24ad2bef538c1e39a78cdff305f1734208000a81" => :el_capitan
    sha256 "7b22a7c2aab941452a5a81907e861043a4a2759691769e7f8d3810a68684bd21" => :yosemite
    sha256 "e60ac97757d5a5a5967f3c16d35f622a0e867d9777521f520b455e258ce92e20" => :mavericks
  end

  depends_on "tor" => [:recommended, :run]

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_f "#{bin}/gcat" # just a symlink that does the same as ocat -I
  end

  test do
    system "#{bin}/ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end

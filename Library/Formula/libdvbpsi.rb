class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.0/libdvbpsi-1.3.0.tar.bz2"
  sha256 "a2fed1d11980662f919bbd1f29e2462719e0f6227e1a531310bd5a706db0a1fe"

  bottle do
    cellar :any
    revision 1
    sha256 "178d6998e890aa2b372c465b2f84591be8ff29b7c0ed9a05d1d84bbf3b90a142" => :yosemite
    sha256 "38be666ffbecf34be0acde507ab0dbf1073ae20f1bb28a82867ca29590feb836" => :mavericks
    sha256 "99794d5fd57bd68552846a917935c59875ba023904a356b710fe9e9effa6172a" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end

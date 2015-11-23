class Mrtg < Formula
  desc "Multi router traffic grapher"
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.4.tar.gz"
  sha256 "5efa7fae8040159208472e5f889be5b41d8c8a2ea6b31616f0f75cc7f48d2365"

  bottle do
    cellar :any
    sha256 "8adea0c04d0319c2bc9a68455cb77c83286a0a0ad0eae32ef386966ec6165abb" => :yosemite
    sha256 "c957f2205d67cd3d35272fcd8ed2a2f61b1938d9541b22e863b55c60fc8b56ee" => :mavericks
    sha256 "be4e5079f3f26f05b3f4eea7e9cb69ec4034d2c67b6a30669b07f29b9d5439a4" => :mountain_lion
  end

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end

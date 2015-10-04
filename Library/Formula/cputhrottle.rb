class Cputhrottle < Formula
  desc "Limit the CPU usage of a process"
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  url "http://www.willnolan.com/cputhrottle/cputhrottle.tar.gz"
  sha256 "fdf284e1c278e4a98417bbd3eeeacf40db684f4e79a9d4ae030632957491163b"
  version "20100515"

  bottle do
    cellar :any
    sha1 "3524fce7418022bea4ea10b2c9e9b794a1876201" => :mavericks
    sha1 "aeb5297fa772631d121d0e480e26e40aa82af5e9" => :mountain_lion
    sha1 "346f0b9b01e890938afe4571fc810dd8afba5664" => :lion
  end

  depends_on "boost" => :build

  def install
    system "make", "all"
    bin.install "cputhrottle"
  end
end

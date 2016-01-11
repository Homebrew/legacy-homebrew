class Cputhrottle < Formula
  desc "Limit the CPU usage of a process"
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  url "http://www.willnolan.com/cputhrottle/cputhrottle.tar.gz"
  version "20100515"
  sha256 "fdf284e1c278e4a98417bbd3eeeacf40db684f4e79a9d4ae030632957491163b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "44be3076a501f8a5ff481e2433528c912496544c2932b1a75ee104b152370386" => :el_capitan
    sha256 "820ba7f42568e30b05492a7a525f69ab916fb8f46dd6d8a367671892434b3f04" => :yosemite
    sha256 "c1d43f7acfc4faa75fd02fa9e76224c542198f7455c394095452963c223d8172" => :mavericks
  end

  depends_on "boost" => :build

  def install
    system "make", "all"
    bin.install "cputhrottle"
  end
end

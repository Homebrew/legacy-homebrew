class Balance < Formula
  desc "Software load balancer"
  homepage "https://www.inlab.de/balance.html"
  url "https://www.inlab.de/balance-3.57.tar.gz"
  sha256 "b355f98932a9f4c9786cb61012e8bdf913c79044434b7d9621e2fa08370afbe1"

  bottle do
    cellar :any
    sha256 "07f517fc19b99e5d52f6a90576ccd718650bd6a291d7c808f0d8b8193bce7779" => :yosemite
    sha256 "ee916620a28cde87c90824125bf418b61eea80bc99e3aa32936e39af8acf0432" => :mavericks
    sha256 "225ecddbc89a491c8ee38988d0a18d175db79d7dec5553ff35d765d2d3ee6638" => :mountain_lion
  end

  def install
    system "make"
    bin.install "balance"
    man1.install "balance.1"
  end
end

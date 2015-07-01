class Balance < Formula
  desc "Software load balancer"
  homepage "https://www.inlab.de/balance.html"
  url "https://www.inlab.de/balance-3.57.tar.gz"
  sha256 "b355f98932a9f4c9786cb61012e8bdf913c79044434b7d9621e2fa08370afbe1"

  def install
    system "make"
    bin.install "balance"
    man1.install "balance.1"
  end
end

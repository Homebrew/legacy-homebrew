require 'formula'

class Balance < Formula
  desc "Software load balancer"
  homepage 'http://www.inlab.de/balance.html'
  url 'http://www.inlab.de/balance-3.56.tar.gz'
  sha1 '04067301a9eda42659e88c3a9438bc1bf8a96902'

  def install
    system "make"
    bin.install "balance"
    man1.install "balance.1"
  end
end

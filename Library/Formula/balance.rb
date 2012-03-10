require 'formula'

class Balance < Formula
  url 'http://www.inlab.de/balance-3.54.tar.gz'
  homepage 'http://www.inlab.de/balance.html'
  md5 '99854615cc58ceb2c5bbf29e35d18018'

  def install
    system "make"

    bin.install "balance"
    man1.install "balance.1"
  end
end

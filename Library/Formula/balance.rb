require 'formula'

class Balance < Formula
  url 'http://www.inlab.de/balance-3.54.tar.gz'
  homepage 'http://www.inlab.de/balance.html'
  sha1 '978ddb395909438a31288f0fad4d163ae997a51b'

  def install
    system "make"

    bin.install "balance"
    man1.install "balance.1"
  end
end

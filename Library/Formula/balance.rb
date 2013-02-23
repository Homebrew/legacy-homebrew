require 'formula'

class Balance < Formula
  homepage 'http://www.inlab.de/balance.html'
  url 'http://www.inlab.de/balance-3.54.tar.gz'
  sha1 '978ddb395909438a31288f0fad4d163ae997a51b'

  def install
    system "make"

    bin.install "balance"
    man1.install "balance.1"
  end
end

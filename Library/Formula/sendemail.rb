require 'formula'

class Sendemail < Formula
  homepage 'http://caspian.dotconf.net/menu/Software/SendEmail/'
  url 'http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz'
  sha1 '5c7c03ce60785c7b7695ec486c84d6e15704df38'

  def install
    bin.install 'sendEmail'
  end

  def test
    system "#{bin}/sendEmail | cat"
  end
end

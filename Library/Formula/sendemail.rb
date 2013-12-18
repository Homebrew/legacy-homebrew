require 'formula'

class Sendemail < Formula
  homepage 'http://caspian.dotconf.net/menu/Software/SendEmail/'
  url 'http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz'
  sha1 '5c7c03ce60785c7b7695ec486c84d6e15704df38'

  def patches
    # Reported upstream:
    # http://caspian.dotconf.net/menu/Software/SendEmail/#comment-1119965648
    { :p1 => "https://raw.github.com/mogaal/sendemail/e785a6d284884688322c9b39c0f64e20a43ea825/debian/patches/fix_ssl_version.patch" }
  end

  def install
    bin.install 'sendEmail'
  end

  test do
    assert_match /sendemail-#{Regexp.escape(version)}/, `#{bin}/sendemail`.strip
  end
end

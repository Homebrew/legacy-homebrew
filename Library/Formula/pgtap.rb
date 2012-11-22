require 'formula'

class Pgtap < Formula
  homepage 'http://pgtap.org'
  url 'http://api.pgxn.org/dist/pgtap/0.91.0/pgtap-0.91.0.zip'
  sha1 '1f10b78eb42361659603228c754a55755fcff4fa'

  depends_on :postgresql

  skip_clean 'share'

  def install
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system "make install"
  end
end

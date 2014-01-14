require 'formula'

class Pgtap < Formula
  homepage   'http://pgtap.org/'
  version    '0.94.0'
  url        "http://api.pgxn.org/dist/pgtap/#{stable.version}/pgtap-#{stable.version}.zip"
  sha1       '58c04a57d79345c18525ed4aee9db058964408a1'
  head       'https://github.com/theory/pgtap.git'

  depends_on :postgresql

  skip_clean 'share'

  def install
    ENV.prepend_path 'PATH', Formula.factory('postgresql').bin
    system "make install"
  end
end

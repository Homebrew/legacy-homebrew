require 'formula'

class Cdb < Formula
  homepage 'http://cr.yp.to/cdb.html'
  url 'http://cr.yp.to/cdb/cdb-0.75.tar.gz'
  sha1 '555749be5b2617e29e44b5326a2536813d62c248'

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make setup"
  end
end

require 'formula'

class Cdb < Formula
  url 'http://cr.yp.to/cdb/cdb-0.75.tar.gz'
  homepage 'http://cr.yp.to/cdb.html'
  md5 '81fed54d0bde51b147dd6c20cdb92d51'

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make setup"
  end
end

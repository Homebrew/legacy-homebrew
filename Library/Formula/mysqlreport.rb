require 'formula'

class Mysqlreport < Formula
  homepage 'http://hackmysql.com/mysqlreport'
  url 'http://hackmysql.com/scripts/mysqlreport-3.5.tgz'
  sha1 '1d54a4a95f6537eea8a4631a6954754e53f19a0e'

  def install
    bin.install "mysqlreport"
    doc.install Dir["*.html"]
  end
end

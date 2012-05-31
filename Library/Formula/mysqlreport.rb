require 'formula'

class Mysqlreport < Formula
  homepage 'http://hackmysql.com/mysqlreport'
  url 'http://hackmysql.com/scripts/mysqlreport-3.5.tgz'
  md5 '33a345f5e2c89b083a9ff0423f7fd7b4'

  def install
    bin.install "mysqlreport"
    doc.install Dir["*.html"]
  end
end

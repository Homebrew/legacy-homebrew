require 'formula'

class Mysqlreport < Formula
  homepage 'http://hackmysql.com/mysqlreport'
  url 'http://hackmysql.com/scripts/mysqlreport-3.5.tgz'
  sha1 '00d2790a9b76422a936f96a622567aa03437b9a3'

  def install
    bin.install "mysqlreport"
    doc.install Dir["*.html"]
  end
end

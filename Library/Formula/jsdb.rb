require 'formula'

class Jsdb < Formula
  url 'http://jsdb.org/jsdb_mac_1.8.0.6.zip'
  homepage 'http://jsdb.org'
  md5 'c98d07ecd08d0a5684e734eecfda97d5'

  # depends_on 'cmake'

  def install
    system "chmod +x ./jsdb"
    bin.install ['jsdb']
  end
end

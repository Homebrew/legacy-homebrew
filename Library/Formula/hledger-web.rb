require 'formula'

class HledgerWeb <Formula
  url 'http://hledger.org/download/hledger-web-0.13-mac-i386.gz', :using => :nounzip
  homepage 'http://hledger.org/'
  md5 '15ac9e078dbcbfd3d88a49b754c68123'
  version '0.13'

  def install
    mkdir bin
    cp downloader.tarball_path, bin/'hledger-web.gz'
    safe_system 'gunzip', bin/'hledger-web.gz'
  end
end

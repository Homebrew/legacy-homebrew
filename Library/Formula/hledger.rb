require 'formula'

class Hledger <Formula
  url 'http://hledger.org/download/hledger-0.13-mac-i386.gz', :using => :nounzip
  homepage 'http://hledger.org/'
  md5 '2e82e2c4eb2a97c50cceff1003a92990'
  version '0.13'

  def install
    mkdir bin
    cp downloader.tarball_path, bin/'hledger.gz'
    safe_system 'gunzip', bin/'hledger.gz'
  end
end

require 'formula'

class HledgerVty <Formula
  url 'http://hledger.org/download/hledger-vty-0.13-mac-i386.gz', :using => :nounzip
  homepage 'http://hledger.org/'
  md5 'ec6cf06cdb02de0a2bf065c4d27ff40e'
  version '0.13'

  def install
    mkdir bin
    cp downloader.tarball_path, bin/'hledger-vty.gz'
    safe_system 'gunzip', bin/'hledger-vty.gz'
  end
end

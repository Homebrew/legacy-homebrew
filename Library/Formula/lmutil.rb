require 'formula'

class Lmutil < Formula
  homepage 'http://www.globes.com/support/fnp_utilities_download.htm'
  url 'http://www.globes.com/products/utilities/v11.10/lmutil_universal_mac10.tar.gz'
  version '11.10'
  sha1 '5c8294459c77dd1a4f5bfc461d2cc3f97dcda4b1'

  def install
    bin.install 'lmutil'
    chmod 0755, bin+'lmutil'
    ln_s bin+'lmutil', bin+'lmstat'
    ln_s bin+'lmutil', bin+'lmdiag'
  end
end

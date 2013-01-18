require 'formula'

class Lmutil < Formula
  homepage 'http://www.globes.com/support/fnp_utilities_download.htm'
  url 'http://www.globes.com/products/utilities/v11.11/lmutil_universal_mac10.tar.gz'
  version '11.11'
  sha1 '9eb15dd48a79304cec7c03a2716970dea2d047e2'

  def install
    bin.install 'lmutil'
    chmod 0755, bin+'lmutil'
    ln_s bin+'lmutil', bin+'lmstat'
    ln_s bin+'lmutil', bin+'lmdiag'
  end
end

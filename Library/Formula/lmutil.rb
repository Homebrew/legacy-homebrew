require 'formula'

class Lmutil <Formula
  url 'http://www.globes.com/products/utilities/v11.8/lmutil_universal_mac10.tar.gz'
  version '11.8'
  homepage 'http://www.globes.com/support/fnp_utilities_download.htm'
  md5 '9754ab4101edf450de31454b6da0eec3'

  # Stripping the binaries would invalidate the code signatures
  skip_clean ['bin']

  def install
    bin.install 'lmutil'
    chmod 0755, bin+'lmutil'
    ln_s bin+'lmutil', bin+'lmstat'
    ln_s bin+'lmutil', bin+'lmdiag'
  end
end

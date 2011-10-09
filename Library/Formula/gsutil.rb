require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  url 'http://gsutil.googlecode.com/files/gsutil_09-06-2011.tar.gz'
  homepage 'http://code.google.com/p/gsutil/'
  md5 'cbb5f16e50bc72df0d9aefa4ebdd08db'
  version '09-06-2011'

  def install
    libexec.install Dir["*"]
    bin.mkpath
    ln_s libexec+'gsutil', bin+'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

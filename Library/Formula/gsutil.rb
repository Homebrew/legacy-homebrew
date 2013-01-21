require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  homepage 'http://code.google.com/p/gsutil/'
  url 'http://commondatastorage.googleapis.com/pub/gsutil_3.21.tar.gz'
  sha1 '286b9c777c714eec48ae595060d3fba40d78e87f'

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

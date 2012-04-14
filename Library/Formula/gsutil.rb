require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  homepage 'https://developers.google.com/storage/docs/gsutil'
  url 'http://commondatastorage.googleapis.com/pub/gsutil.tar.gz'
  sha1 '93f35fcf9f45ee85d7916e3cc1c62b2afbde0f67'
  version '3.4'

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec+'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

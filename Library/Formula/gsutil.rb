require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. 
#
# Note: We can not use the github tag download version because it doesn't 
# include the third_party directory.
#
# References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  homepage 'https://github.com/GoogleCloudPlatform/gsutil'
  url 'http://storage.googleapis.com/pub/gsutil_3.9.tar.gz'
  sha1 '33e728bc5d6d26c81737446843ffa0f9a5dbc8b5'

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  homepage 'https://github.com/GoogleCloudPlatform/gsutil'
  url 'https://github.com/GoogleCloudPlatform/gsutil/archive/v3.29.tar.gz'
  sha1 'ae224258bcd1aa14c7dd5106766ec48640f815c8'

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

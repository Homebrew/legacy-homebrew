require 'formula'

# This is a pure Python formula, but Google suck and won't provide it in PYPI.
# So fearlessly we elect to maintain the formula. References:
# https://github.com/mxcl/homebrew/pull/7484
# https://github.com/mxcl/homebrew/issues/2560

class Gsutil < Formula
  homepage 'http://code.google.com/p/gsutil/'
  url 'http://gsutil.googlecode.com/files/gsutil_01-13-2012.tar.gz'
  sha1 'fe1aa1c5fe5b3d7d099fc37367d8fc15acb99435'
  version '2012-01-13'

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec+'gsutil'
  end

  def test
    system "#{bin}/gsutil"
  end
end

require 'formula'

class Stlviewer < Formula
  homepage 'https://github.com/vishpat/stlviewer#readme'
  url 'https://github.com/vishpat/stlviewer/archive/release-0.1.tar.gz'
  sha1 '2ceeee6e36de4b9e95002940d893819fb9e09120'

  def install
    system './compile.py'
    bin.install 'stlviewer'
  end
end

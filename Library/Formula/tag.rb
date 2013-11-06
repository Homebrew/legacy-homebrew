require 'formula'

class Tag < Formula
  homepage 'https://github.com/jdberry/tag/'
  url 'https://github.com/jdberry/tag/archive/v0.7.3.tar.gz'
  sha1 'aaab77f51eeacde2fdd75a7c56403c0d620b7970'
  head 'https://github.com/jdberry/tag.git'

  depends_on :macos => :mavericks

  def install
    system 'make'
    bin.install 'bin/tag'
  end
end

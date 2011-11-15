require 'formula'

class Fsrip < Formula
  head 'https://github.com/jonstewart/fsrip.git'
  homepage 'http://github.com/jonstewart/fsrip'

  depends_on 'scons' => :build
  depends_on 'boost'
  depends_on 'sleuthkit'

  def install
    system 'scons', 'boostType="-mt"'
    prefix.install %w{ LICENSE.txt HttpProtocol.txt README.txt }
    bin.install 'build/src/fsrip' => 'fsrip'
  end

  def test
    system "fsrip"
  end
end
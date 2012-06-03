require 'formula'

class Flvtoolxx < Formula
  url 'https://github.com/Elbandi/flvtool-pp/tarball/upstream/1.2.1'
  version '1.2.1'
  homepage 'https://github.com/Elbandi/flvtool-pp'
  md5 'e942a396cad1a557af444450e8281efa'

  depends_on 'scons' => :build
  depends_on 'boost'

  def install
    system 'scons'
    bin.install 'flvtool++'
  end
end

require 'formula'

class GpawSetups < Formula
  homepage 'https://wiki.fysik.dtu.dk/gpaw/'
  url 'https://wiki.fysik.dtu.dk/gpaw-files/gpaw-setups-0.9.9672.tar.gz'
  sha1 'f48a98b92e2f31dee21ce487a5f112a7ada06af6'

  def install
    Dir.mkdir 'gpaw-setups'
    system 'mv *.gz *.pckl gpaw-setups'
    share.mkpath
    share.install Dir['*']
    ENV.j1  # if your formula's build system can't parallelize
  end

  def test
    system "ls #{share}/gpaw-setups"
  end
end

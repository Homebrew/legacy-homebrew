require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://google-compute-engine-tools.googlecode.com/files/gcutil-1.5.0.tar.gz'
  version '1.5.0'
  sha1 '785290893ab722f2a1510f37982e80e52f9f043a'

  def install
    bin.mkpath
    prefix.install Dir['*']
    bin.install_symlink (prefix + "gcutil")
  end

  def test
    system "gcutil version"
  end
end

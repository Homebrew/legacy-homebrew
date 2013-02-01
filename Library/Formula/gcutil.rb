require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://google-compute-engine-tools.googlecode.com/files/gcutil-1.6.0.tar.gz'
  sha1 '4ec33566190264f3550a2fe9ae950ee9c64a81ed'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  def test
    system "#{bin}/gcutil", "version"
  end
end

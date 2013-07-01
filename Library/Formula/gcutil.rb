require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://google-compute-engine-tools.googlecode.com/files/gcutil-1.8.2.tar.gz'
  sha1 '6213f14cc07e789493bc36fef18c4ea8e6285b64'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  def test
    system "#{bin}/gcutil", "version"
  end
end

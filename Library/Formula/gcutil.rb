require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://google-compute-engine-tools.googlecode.com/files/gcutil-1.9.1.tar.gz'
  sha1 '70035c803d983aa30f0d01e6ffd7873cac76f9ce'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  def test
    system "#{bin}/gcutil", "version"
  end
end

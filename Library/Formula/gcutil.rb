require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://google-compute-engine-tools.googlecode.com/files/gcutil-1.8.4.tar.gz'
  sha1 'cf5d094df8fa847befad98d8b3507091822a798e'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  def test
    system "#{bin}/gcutil", "version"
  end
end

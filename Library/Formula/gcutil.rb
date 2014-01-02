require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.12.0.zip'
  sha1 'f4bafdd11a0a03d9be3f5c238af66933f811fbfe'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  def test
    system "#{bin}/gcutil", "version"
  end
end

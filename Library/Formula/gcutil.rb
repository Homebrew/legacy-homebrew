require 'formula'

class Gcutil < Formula
  homepage 'https://developers.google.com/compute/docs/gcutil/'
  url 'https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.14.0.zip'
  sha1 '10f34bfee7e3865cad14ad27caae446aedab9038'

  def install
    libexec.install 'gcutil', 'lib'
    bin.install_symlink libexec/"gcutil"
  end

  test do
    system "#{bin}/gcutil", "version"
  end
end

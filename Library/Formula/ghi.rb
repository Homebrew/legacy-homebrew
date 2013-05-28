require 'formula'

class Ghi < Formula
  homepage 'https://github.com/stephencelis/ghi'
  url 'https://github.com/stephencelis/ghi/archive/0.9.0.201304025.zip'
  sha1 '13774729cdf6d140e2cd48f661fbcc5b00bfdd33'

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "ghi --version"
  end
end

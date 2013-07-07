require 'formula'

class Ghi < Formula
  homepage 'https://github.com/stephencelis/ghi'
  url 'https://github.com/stephencelis/ghi/archive/0.9.0.20130504.zip'
  sha1 '64537496f2214bdfbd7a2e71f57eabd6de90108b'

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

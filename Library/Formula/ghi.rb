require 'formula'

class Ghi < Formula
  homepage 'https://github.com/stephencelis/ghi'
  url 'https://github.com/stephencelis/ghi/archive/0.9.3.tar.gz'
  head 'https://github.com/stephencelis/ghi.git'
  sha1 '59512443c778cacc8c0488e6ab64965f18b3a279'

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

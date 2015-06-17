require 'formula'

class Shunit2 < Formula
  desc "xUnit unit testing framework for Bourne-based shell scripts"
  homepage 'https://code.google.com/p/shunit2/'
  url 'https://shunit2.googlecode.com/files/shunit2-2.1.6.tgz'
  sha1 '9cd0e1834b221c378c2f8a6f0baf10410e53680f'

  def install
    bin.install 'src/shunit2'
  end

  test do
    system "#{bin}/shunit2"
  end
end

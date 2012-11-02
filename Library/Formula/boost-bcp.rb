require 'formula'

class BoostBcp < Formula
  homepage 'http://www.boost.org/doc/libs/1_51_0/tools/bcp/doc/html/index.html'
  url 'https://github.com/downloads/alemacgo/bcp/bcp_1_51.tar.gz'
  sha1 'cd80a8a2caa40ce619300891c170c3a361595885'

  depends_on 'boost'

  def install
    system "make install"
  end

  def test
    system "bcp"
  end
end

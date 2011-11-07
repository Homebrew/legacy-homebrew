require 'formula'

class Quvi < Formula
  url 'http://downloads.sourceforge.net/project/quvi/0.4/quvi/quvi-0.4.0.tar.bz2'
  sha1 '79784b47223d77188ba2cc2c905d7fb530d8c71b'
  homepage 'http://quvi.sourceforge.net/'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'lua'
  depends_on 'libquvi'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/quvi --version"
  end
end

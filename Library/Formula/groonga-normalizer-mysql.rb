require 'formula'

class GroongaNormalizerMysql < Formula
  homepage 'https://github.com/groonga/groonga-normalizer-mysql'
  url 'http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.3.tar.gz'
  sha1 '8df28c84ba68614fe588e70fd17299cae2701068'

  depends_on 'pkg-config' => :build
  depends_on 'groonga'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

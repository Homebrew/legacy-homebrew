require 'formula'

class GroongaNormalizerMysql < Formula
  homepage 'https://github.com/groonga/groonga-normalizer-mysql'
  url 'http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.6.tar.gz'
  sha1 '61d27a4782d4821be7d26e07cf207c6d7f719ebf'

  depends_on 'pkg-config' => :build
  depends_on 'groonga'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

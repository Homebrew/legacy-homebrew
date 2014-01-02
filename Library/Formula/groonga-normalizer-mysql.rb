require 'formula'

class GroongaNormalizerMysql < Formula
  homepage 'https://github.com/groonga/groonga-normalizer-mysql'
  url 'http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.5.tar.gz'
  sha1 '37d35c50b2609b1ce006248e8cca22d6634f0f8e'

  depends_on 'pkg-config' => :build
  depends_on 'groonga'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

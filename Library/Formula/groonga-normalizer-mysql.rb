require 'formula'

class GroongaNormalizerMysql < Formula
  homepage 'https://github.com/groonga/groonga-normalizer-mysql'
  url 'http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.1.tar.gz'
  sha1 'ccd0bdefbf513e8f1c93dec975f97ab4ad715013'

  depends_on 'pkg-config' => :build
  depends_on 'groonga'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

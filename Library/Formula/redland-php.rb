require 'formula'

class RedlandPhp < Formula
  homepage 'http://librdf.org/bindings/'
  url 'http://download.librdf.org/source/redland-bindings-1.0.14.1.tar.gz'
  sha1 'b7e137498c190ba49409a7b91fbd3962b7ebcbef'

  depends_on 'swig' => :build
  depends_on 'redland'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-php",
                          "--with-php-linking=bundle",
                          "--without-lua",
                          "--without-perl",
                          "--without-python",
                          "--without-ruby"
    system "make install"
  end
end

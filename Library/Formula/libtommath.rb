require 'formula'

class Libtommath < Formula
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  sha1 '9b192701cf62b85e9bd65fbb4d622d04cfa5ee0d'

  def install
    ENV['DESTDIR'] = prefix
    system "make"
    include.install Dir['tommath*.h']
    lib.install 'libtommath.a'
  end
end

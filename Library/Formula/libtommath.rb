require 'formula'

class Libtommath < Formula
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  sha1 '9b192701cf62b85e9bd65fbb4d622d04cfa5ee0d'

  bottle do
    cellar :any
    revision 1
    sha1 "fe3bb489505e96a505676c1cbca5ebc554c8990c" => :yosemite
    sha1 "59fa62fa21fbdb2e938d40cf6171c074db8f2e05" => :mavericks
  end

  def install
    ENV['DESTDIR'] = prefix
    system "make"
    include.install Dir['tommath*.h']
    lib.install 'libtommath.a'
  end
end

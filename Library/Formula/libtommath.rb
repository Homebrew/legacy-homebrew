require 'formula'

class Libtommath < Formula
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  sha1 '9b192701cf62b85e9bd65fbb4d622d04cfa5ee0d'

  bottle do
    cellar :any
    sha1 "2a4fe84f016de2fa55f610fce1671fe8b561a43f" => :mavericks
    sha1 "57a06b4dc313447d1032d43e3a2fec2f939896c7" => :mountain_lion
    sha1 "a6eb6cf4910a879832026765152f821976c776c7" => :lion
  end

  def install
    ENV['DESTDIR'] = prefix
    system "make"
    include.install Dir['tommath*.h']
    lib.install 'libtommath.a'
  end
end

require 'formula'

class Pgrouting < Formula
  homepage 'http://www.pgrouting.org'
  version "2.0.0-beta"
  url 'https://github.com/pgRouting/pgrouting/archive/v2.0.0-beta.tar.gz'
  sha1 'fbe661aae7e2474114f8bd9b71138986b3addf0b'

  depends_on 'postgresql'
  depends_on 'postgis'
  depends_on 'boost'
  depends_on 'cgal' 
  depends_on 'cmake' => :build
  
  def install
    system "cmake -DWITH_DD=ON"
    system "make", "install" 
  end
end

require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-1.0.2.tar.gz'
  sha1 'fe6a910a90cde80137153e25e175e2b211beda36'

  def install
    # prevent 'cc1plus: error: unrecognized command line option "-Wno-long-double"'
    inreplace 'configure', 'CXXFLAGS="$CXXFLAGS -Wno-long-double"', ''

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


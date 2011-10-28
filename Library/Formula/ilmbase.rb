require 'formula'

class Ilmbase < Formula
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-1.0.2.tar.gz'
  homepage 'http://www.openexr.com/'
  md5 '26c133ee8ca48e1196fbfb3ffe292ab4'

  # included for reference only - repository doesn't have 'configure' script
  # head 'cvs://:pserver:anonymous@cvs.sv.gnu.org:/sources/openexr:IlmBase'

  def install
    # prevent 'cc1plus: error: unrecognized command line option "-Wno-long-double"'
    inreplace 'configure', 'CXXFLAGS="$CXXFLAGS -Wno-long-double"', ''

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end


require 'formula'

class Openexr < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/openexr-1.7.0.tar.gz'
  sha1 '91d0d4e69f06de956ec7e0710fc58ec0d4c4dc2b'

  # included for reference only - repository doesn't have 'configure' script
  # head 'cvs://:pserver:anonymous@cvs.sv.gnu.org:/sources/openexr:OpenEXR'

  depends_on 'pkg-config' => :build
  depends_on 'ilmbase'

  def install
    # prevent 'cc1plus: error: unrecognized command line option "-Wno-long-double"'
    inreplace 'configure', 'CXXFLAGS="$CXXFLAGS -Wno-long-double"', ''

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


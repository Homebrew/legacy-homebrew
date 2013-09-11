require 'formula'

class Openexr < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/openexr-2.0.1.tar.gz'
  sha1 '22589e11d090a01b5c3117e7e0b7bbb8301184b6'

  # included for reference only - repository doesn't have 'configure' script
  # head 'cvs://:pserver:anonymous@cvs.sv.gnu.org:/sources/openexr:OpenEXR'

  depends_on 'pkg-config' => :build
  depends_on 'ilmbase'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


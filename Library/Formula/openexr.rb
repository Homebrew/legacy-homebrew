require 'formula'

class Openexr < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/openexr-2.1.0.tar.gz'
  sha1 '4a3db5ea527856145844556e0ee349f45ed4cbc7'

  bottle do
    cellar :any
    sha1 "ea725dc6cbc2d136e76207c9d35a7be7458a3cfb" => :mavericks
    sha1 "ed396fb53bd47b21972f543b7a5eb374d4f023f0" => :mountain_lion
    sha1 "b22c4937ea4053246781c1469cb11b6eb9290d94" => :lion
  end

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


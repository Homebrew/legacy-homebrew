require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'http://downloads.sf.net/project/freetype/freetype2/2.4.10/freetype-2.4.10.tar.gz'
  sha1 '44dba26ff965b1cd1c62e480fdefaeca62ed33da'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    # Included with X11 so no bottle needed before Mountain Lion.
    sha1 '02121cf64c189e61117dc9bef3de856f296761af' => :mountainlion
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/freetype-config --ftversion"
  end
end

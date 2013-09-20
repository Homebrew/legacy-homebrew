require 'formula'

class Geos < Formula
  homepage 'http://trac.osgeo.org/geos'
  url 'http://download.osgeo.org/geos/geos-3.4.2.tar.bz2'
  sha1 'b8aceab04dd09f4113864f2d12015231bb318e9a'

  option :universal
  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion

  def install
    ENV.universal_binary if build.universal?

# what want we build?
    if build.with? 'c++11'
        system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "CXX=clang++ -std=c++11 -stdlib=libc++"
    else
        system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    end
    system "make install"
  end
end


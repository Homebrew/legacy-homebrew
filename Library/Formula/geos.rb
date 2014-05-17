require 'formula'

class Geos < Formula
  homepage 'http://trac.osgeo.org/geos'
  url 'http://download.osgeo.org/geos/geos-3.4.2.tar.bz2'
  sha1 'b8aceab04dd09f4113864f2d12015231bb318e9a'

  bottle do
    cellar :any
    sha1 "4ac17dfbdba05100815488176ba8afeeb97a9319" => :mavericks
    sha1 "a49a9202b50c9d6f0f5572661c528b9e2f9f429a" => :mountain_lion
    sha1 "c00c210e9fc5da69cb182f96d1e3a642980ebc1d" => :lion
  end

  option :universal
  option :cxx11

  fails_with :llvm

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Proj < Formula
  homepage 'http://trac.osgeo.org/proj/'
  url 'http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
  sha1 '5c8d6769a791c390c873fef92134bf20bb20e82a'

  bottle do
    sha1 "08e30f4cf0b09f9f8d61e6ec73f025a8521039f4" => :mavericks
    sha1 "22bc868bb7198300724e837c2463b2f8cd31f942" => :mountain_lion
    sha1 "c25de74f90c56f3deff6ac1a0984fba265ececb2" => :lion
  end

  # The datum grid files are required to support datum shifting
  resource 'datumgrid' do
    url 'http://download.osgeo.org/proj/proj-datumgrid-1.5.zip'
    sha1 '4429ba1a8c764d5c0e6724d868f6874f452f7440'
  end

  skip_clean :la

  fails_with :llvm do
    build 2334
  end

  def install
    (buildpath/'nad').install resource('datumgrid')
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

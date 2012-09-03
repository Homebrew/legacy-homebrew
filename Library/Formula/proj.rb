require 'formula'

class ProjDatumgrid < Formula
  url 'http://download.osgeo.org/proj/proj-datumgrid-1.5.zip'
  sha1 '4429ba1a8c764d5c0e6724d868f6874f452f7440'
end

class Proj < Formula
  url 'http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
  homepage 'http://trac.osgeo.org/proj/'
  sha1 '5c8d6769a791c390c873fef92134bf20bb20e82a'

  fails_with :llvm do
    build 2334
  end

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    # The datum grid files are required to support datum shifting
    ProjDatumgrid.new.brew { cp Dir["*"], buildpath/'nad' }

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

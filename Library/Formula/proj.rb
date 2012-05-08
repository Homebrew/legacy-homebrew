require 'formula'

class ProjDatumgrid < Formula
  url 'http://download.osgeo.org/proj/proj-datumgrid-1.5.zip'
  md5 'f5bf28a2a9c6afe9a3f670f0c0adb783'
end

class Proj < Formula
  url 'http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
  homepage 'http://trac.osgeo.org/proj/'
  md5 'd815838c92a29179298c126effbb1537'

  fails_with :llvm do
    build 2334
  end

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    # The datum grid files are required to support datum shifting
    ProjDatumgrid.new.brew { cp Dir["*"], buildpath/'nad' }

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

require 'formula'

class ProjDatumgrid <Formula
  url 'http://download.osgeo.org/proj/proj-datumgrid-1.5.zip'
  md5 'f5bf28a2a9c6afe9a3f670f0c0adb783'
end

class Proj <Formula
  url 'http://download.osgeo.org/proj/proj-4.7.0.tar.gz'
  homepage 'http://trac.osgeo.org/proj/'
  md5 '927d34623b52e0209ba2bfcca18fe8cd'

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    ENV.gcc_4_2

    # The datum grid files are required to support datum shifting
    d = Dir.getwd
    ProjDatumgrid.new.brew { FileUtils.cp Dir["*"], "#{d}/nad/" }

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end


require 'formula'

class Sedna < Formula
  homepage 'http://modis.ispras.ru/sedna/index.html'
  url 'http://www.modis.ispras.ru/FTPContent/sedna/current/sedna-3.4.66-src-darwin.tar.gz'
  md5 '8c0006dbfb0ab89a63b4ae93e35f2213'

  depends_on 'cmake' => :build

  def install
    # Build needs to be created from outside the source directory.
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    If this is your first install, create a database with:
        se_cdb <db name>

    Start your database manually with:
        se_gov && se_sm <db name>

    And stop with:
        se_stop
    EOS
  end
end

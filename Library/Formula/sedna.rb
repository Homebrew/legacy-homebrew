require 'formula'

class Sedna < Formula
  url 'http://www.modis.ispras.ru/FTPContent/sedna/current/sedna-3.4.66-src-darwin.tar.gz'
  homepage 'http://modis.ispras.ru/sedna/index.html'
  md5 '8c0006dbfb0ab89a63b4ae93e35f2213'
  version '3.4.66'

  depends_on 'cmake' => :build

  def install
    path = pwd
    # Build needs to be created from outside the source directory.
    mktemp do
      system "cmake #{path} #{std_cmake_parameters}"
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

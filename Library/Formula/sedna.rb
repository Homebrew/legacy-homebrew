require 'formula'

class Sedna <Formula
  url 'http://www.modis.ispras.ru/FTPContent/sedna/current/sedna-3.4.59-src-darwin.tar.gz'
  homepage 'http://modis.ispras.ru/sedna/index.html'
  md5 '77a946163d60ace1bc940b8b71267a31'
  version '3.4.59'

  depends_on 'cmake'

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

require 'formula'

class Sedna < Formula
  homepage 'http://www.sedna.org/index.html'
  url 'http://www.modis.ispras.ru/FTPContent/sedna/current/sedna-3.5.161-src-darwin.tar.gz'
  sha1 '8a30104b5c2027c6915bd9cfa44d72ef24b025ce'

  depends_on 'cmake' => :build

  def install
    mkdir 'bld' do
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

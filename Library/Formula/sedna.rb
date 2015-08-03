class Sedna < Formula
  desc "XML database"
  homepage "http://www.sedna.org/index.html"
  url "http://www.modis.ispras.ru/FTPContent/sedna/current/sedna-3.5.161-src-darwin.tar.gz"
  sha256 "f59fc991fc9daa8d1e6f15ac699f59b5fb9168c54c288738113b90df89f543d4"

  depends_on "cmake" => :build

  def install
    mkdir "bld" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
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

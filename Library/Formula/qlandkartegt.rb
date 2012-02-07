require 'formula'

class Qlandkartegt < Formula
  url 'http://sourceforge.net/projects/qlandkartegt/files/qlandkartegt/QLandkarteGT%201.3.2/qlandkartegt-1.3.2.tar.gz'
  homepage 'http://www.qlandkarte.org/'
  md5 '1dc1b7284b15231978f9d0ec6353cf65'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'gdal'
  depends_on 'proj'
  depends_on 'libexif'
  depends_on 'libdmtx'
  depends_on 'jpeg'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make"

    prefix.install "bin/QLandkarte GT.app"
  end

  def caveats; <<-EOS
    QLandkarte GT.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end

end

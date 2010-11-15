require 'formula'

class Tcsh <Formula
  url 'ftp://ftp.astron.com/pub/tcsh/tcsh-6.17.00.tar.gz'
  homepage 'http://www.tcsh.org/'
  md5 'c47de903e3d52f6824c8dd0c91eeb477'
  version '6.17.00'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

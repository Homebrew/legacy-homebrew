require 'formula'

class Banner <Formula
  url "http://cedar-solutions.com/ftp/software/banner-1.3.2.tar.gz"
  md5 'b7474ffeee1b30fdea4f9c5f90415b44'
  homepage 'http://cedar-solutions.com/software/utilities.html'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end

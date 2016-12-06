require 'formula'

class Banner < Formula
  homepage 'http://software.cedar-solutions.com/utilities.html'
  url 'http://software.cedar-solutions.com/ftp/software/banner-1.3.2.tar.gz'
  sha1 'd9dce94630a26bed574398c6eb5ebe53ec231fd4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

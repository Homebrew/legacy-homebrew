require 'formula'

class Xlslib < Formula
  homepage 'http://sourceforge.net/projects/xlslib'
  url 'https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.4.0.zip'
  sha1 '73447c5c632c0e92c1852bd2a2cada7dd25f5492'

  def install
    cd 'xlslib'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

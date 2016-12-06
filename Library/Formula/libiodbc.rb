require 'formula'

class Libiodbc < Formula
  homepage 'https://github.com/openlink/iODBC'
  url 'http://surfnet.dl.sourceforge.net/project/iodbc/iodbc/3.52.8/libiodbc-3.52.8.tar.gz'
  sha1 '93a3f061afff3152c5fcee1e5af8b802760a7e74'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-layout=gnu", "--with-iodbc-inidir=#{etc}"
                          
    system "make", "install"
  end

  test do
    system "iodbc-config --version"
  end
end

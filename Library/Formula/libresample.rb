require 'formula'

class Libresample < Formula
  homepage 'https://ccrma.stanford.edu/~jos/resample/Available_Software.html'
  url 'http://ftp.de.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz'
  sha1 '85339a6114627e27010856f42a3948a545ca72de'

  bottle do
    cellar :any
    sha1 "4a4ca882e7c1dba34f34e6851c9972d16fc30cff" => :mavericks
    sha1 "d12aba16db7faaea37347936ca47059d8c52ad82" => :mountain_lion
    sha1 "dc264e31f92f7397900fd6284702c42d08d88374" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install 'libresample.a'
    include.install 'include/libresample.h'
  end
end

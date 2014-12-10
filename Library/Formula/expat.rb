require 'formula'

class Expat < Formula
  homepage 'http://expat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz'
  sha1 'b08197d146930a5543a7b99e871cba3da614f6f0'

  bottle do
    cellar :any
    revision 1
    sha1 "bed02c89a0fdaf86c6f61fb81fa02d8962583de8" => :yosemite
    sha1 "d4b5ee6b854e860ca3c465aa970ffbe881f1358f" => :mavericks
    sha1 "fd958aab5f15b738ed4432b3694e68731021c256" => :mountain_lion
  end

  keg_only :provided_by_osx, "OS X includes Expat 1.5."

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

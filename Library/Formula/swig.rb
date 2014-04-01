require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'https://downloads.sourceforge.net/project/swig/swig/swig-3.0.0/swig-3.0.0.tar.gz'
  sha1 '10a1cc5ba6abbc7282b8146ccc0d8eefe233bfab'

  bottle do
    sha1 "24b5a7ea2ceb3671b471f637acf9c4e200786daf" => :mavericks
    sha1 "cf97971c41a373794b486f90eb635fec9d211781" => :mountain_lion
    sha1 "a2cc53440ae191f9020019c851a83c2929fb249f" => :lion
  end

  option :universal

  depends_on 'pcre'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

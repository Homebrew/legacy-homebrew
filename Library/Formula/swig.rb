require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'https://downloads.sourceforge.net/project/swig/swig/swig-3.0.0/swig-3.0.0.tar.gz'
  sha1 '10a1cc5ba6abbc7282b8146ccc0d8eefe233bfab'

  bottle do
    sha1 "ee2c0b5ce1e8558b526db86beff4dedd34f5905b" => :mavericks
    sha1 "bbb7e1d501d7b31c9df4ecbe49444ad5f00d808c" => :mountain_lion
    sha1 "319772da45f1346ae49486c8851156351ef9f5af" => :lion
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

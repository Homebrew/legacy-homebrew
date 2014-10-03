require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.5.7.tar.bz2'
  sha1 '173d87d11d02a524037228f6495c46cad3214b7d'

  bottle do
    sha1 "e990208b2865d65af9036ba5733f4e6be9ce040a" => :mavericks
    sha1 "ca81f3114ba63c60a4227caece426a0f433a85f6" => :mountain_lion
    sha1 "b6c2ac9694c5511ea01be56570ded954aca4d645" => :lion
  end

  depends_on 'gettext'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

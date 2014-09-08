require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.5.3.tar.bz2'
  sha1 '8cb04ca5c2318e4da0dc88f87f16cea6e1901bef'

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

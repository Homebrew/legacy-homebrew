require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.5.3.tar.bz2'
  sha1 '8cb04ca5c2318e4da0dc88f87f16cea6e1901bef'

  bottle do
    sha1 "13db5f53546f554a1a1cef88f763022e0ba08974" => :mavericks
    sha1 "96bedf90d0688c722e7fe1743230e74713089ef9" => :mountain_lion
    sha1 "cea67d8b62b936e80dfa80fe7d84706bbd258e29" => :lion
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

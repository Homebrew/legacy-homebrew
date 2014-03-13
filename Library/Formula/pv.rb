require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.5.2.tar.bz2'
  sha1 '0ca480d0ef2400bb9ebe9a992e011a9f004f42b8'

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

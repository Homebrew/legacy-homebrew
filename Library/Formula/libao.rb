require 'formula'

class Libao <Formula
  url 'http://downloads.xiph.org/releases/ao/libao-1.0.0.tar.gz'
  md5 '08283fbe1f587619053a156254afecec'
  homepage 'http://www.xiph.org/ao/'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-x"
    system "make install"
  end

  def patches
    [
        # Fix build on OS X 10.4 and 10.5 (included in upcoming 1.0.1)
        "https://trac.xiph.org/raw-attachment/ticket/1667/libao.patch"
    ]
  end
end

require 'formula'

class Btpd <Formula
  url 'http://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz'
  homepage 'http://github.com/btpd/btpd'
  md5 'fe042aae8d7c515ecd855673d1c2b33e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

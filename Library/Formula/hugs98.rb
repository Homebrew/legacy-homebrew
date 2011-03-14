require 'formula'

class Hugs98 < Formula
  url 'http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-plus-Sep2006.tar.gz'
  version 'plus-Sep2006'
  homepage 'http://www.haskell.org/hugs/'
  md5 'e03e0ad79750d037237c47ebe33fa20e'

  depends_on 'readline'

  def patches
    { :p0 => [
      "http://trac.macports.org/export/72943/trunk/dports/lang/hugs98/files/patch-packages-base-include-HsBase.h.diff",
      "https://trac.macports.org/raw-attachment/ticket/20950/patch-libraries-tools-make-bootlib.diff"
    ] }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

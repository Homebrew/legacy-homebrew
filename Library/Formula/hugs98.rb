require 'formula'

class Hugs98 < Formula
  homepage 'http://www.haskell.org/hugs/'
  url 'http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-plus-Sep2006.tar.gz'
  version 'plus-Sep2006'
  sha1 '1464a80c715bc5f786ea5a4e4257b2ff0dc7e1e9'

  depends_on 'readline'

  fails_with :clang do
    build 421
    cause %[runhugs: Error occurred\nERROR "libraries/bootlib/Data/Bits.hs":192 - Syntax error in declaration (unexpected `}', possibly due to bad layout)]
  end

  def patches
    {:p0 => [
      "https://trac.macports.org/export/80246/trunk/dports/lang/hugs98/files/patch-packages-base-include-HsBase.h.diff",
      "https://trac.macports.org/export/80246/trunk/dports/lang/hugs98/files/patch-libraries-tools-make-bootlib.diff"
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

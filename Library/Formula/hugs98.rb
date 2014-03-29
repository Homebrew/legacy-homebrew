require 'formula'

class Hugs98 < Formula
  homepage 'http://www.haskell.org/hugs/'
  url 'http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-plus-Sep2006.tar.gz'
  version 'plus-Sep2006'
  sha1 '1464a80c715bc5f786ea5a4e4257b2ff0dc7e1e9'

  depends_on 'readline'

  fails_with :clang do
    cause %[ERROR "../libraries/bootlib/Data/Dynamic.hs" - Module "Main" already loaded]
  end

  patch :p0 do
    url "https://trac.macports.org/export/80246/trunk/dports/lang/hugs98/files/patch-packages-base-include-HsBase.h.diff"
    sha1 "2cc58901ec6e8d81bda8d73230cb0a27b320cf94"
  end

  patch :p0 do
    url "https://trac.macports.org/export/80246/trunk/dports/lang/hugs98/files/patch-libraries-tools-make-bootlib.diff"
    sha1 "acd32ba7fda404f9c33791c253e14e801ffd4e2f"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

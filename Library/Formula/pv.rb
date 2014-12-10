require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.5.7.tar.bz2'
  sha1 '173d87d11d02a524037228f6495c46cad3214b7d'

  bottle do
    sha1 "74c116553193e57d114106e970b9c49b9f4104b5" => :mavericks
    sha1 "d5a03a105681454bdb9bb27259a7b590dd12afa8" => :mountain_lion
    sha1 "47a5ca248413625e8b70de1b13a96c313c5952ed" => :lion
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

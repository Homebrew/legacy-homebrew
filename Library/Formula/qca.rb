require 'formula'

class Qca < Formula
  homepage 'http://delta.affinix.com/qca/'
  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.3.tar.bz2'
  sha1 '9c868b05b81dce172c41b813de4de68554154c60'

  depends_on 'qt'

  # Fix for clang adhering strictly to standard, see:
  # http://clang.llvm.org/compatibility.html#dep_lookup_bases
  patch do
    url "http://quickgit.kde.org/?p=qca.git&a=commitdiff&h=312b69&o=plain"
    sha1 "f3b1f645e35f46919d9bf9ed6f790619c7d03631"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-tests"
    system "make install"
  end
end

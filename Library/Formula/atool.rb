require 'formula'

class Atool < Formula
  homepage 'http://www.nongnu.org/atool/'
  url 'http://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz'
  md5 'e0aa006decbc6484b9dba2879f1bb9f0'

  depends_on "gnu-sed"

  def install
    system "./configure", "--prefix=#{prefix}"
    # OS X sed doesn't work; use GNU sed
    inreplace 'Makefile', 'sed -r', '#{HOMEBREW_PREFIX}/bin/gsed'
    system "make install"
  end
end

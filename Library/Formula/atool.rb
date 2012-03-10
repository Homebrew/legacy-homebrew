require 'formula'

class Atool < Formula
  url 'http://savannah.nongnu.org/download/atool/atool-0.38.0.tar.gz'
  homepage 'http://www.nongnu.org/atool/'
  md5 'bf05a07f7b35415d146b2e21edc1ebbf'

  depends_on "gnu-sed"

  def install
    system "./configure", "--prefix=#{prefix}"
    # OS X sed doesn't work; use GNU sed
    inreplace 'Makefile', 'sed -r', '#{HOMEBREW_PREFIX}/bin/gsed'
    system "make install"
  end
end

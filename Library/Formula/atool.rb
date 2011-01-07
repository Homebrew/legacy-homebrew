require 'formula'

class Atool <Formula
  url 'http://savannah.nongnu.org/download/atool/atool-0.37.0.tar.gz'
  homepage 'http://www.nongnu.org/atool/'
  md5 '2607e9b19518af4145be8a6bed454477'

  depends_on "gnu-sed"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    # OS X sed doesn't work; use GNU sed
    inreplace 'Makefile', 'sed -r', '#{HOMEBREW_PREFIX}/bin/gsed'
    system "make install"
  end
end

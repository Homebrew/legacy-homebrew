require 'formula'

class Make <Formula
  url 'http://ftp.gnu.org/gnu/make/make-3.82.tar.gz'
  homepage 'http://www.gnu.org/software/make/'
  md5 '7f7c000e3b30c6840f2e9cf86b254fac'

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "/usr/bin/gnumake install"
  end
end

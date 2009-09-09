require 'brewkit'

class Slang <Formula
  @url='ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.0.tar.gz'
  @homepage='http://www.s-lang.org/'
  @md5='81cd7456c70a21937497f4b04b77433c'

  def deps
    OptionalLibraryDep.new 'pcre'
    OptionalLibraryDep.new 'oniguruma'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking --with-png=/usr/X11R6"
    system "make"
    
    ENV.deparallelize
    system "make install"
  end
end

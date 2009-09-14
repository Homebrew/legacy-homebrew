require 'brewkit'

class Rasqal <Formula
  @url='http://download.librdf.org/source/rasqal-0.9.16.tar.gz'
  @homepage='http://librdf.org/rasqal/'
  @md5='fca8706f2c4619e2fa3f8f42f8fc1e9d'

  def deps
    LibraryDep.new 'raptor'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

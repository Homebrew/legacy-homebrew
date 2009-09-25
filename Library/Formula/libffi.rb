require 'brewkit'

class Libffi <Formula
  @url='ftp://sourceware.org/pub/libffi/libffi-3.0.8.tar.gz'
  @homepage='http://sourceware.org/libffi/'
  @sha1='ce44d10c39d9a37479c8777e206cac0f36c48712'

  def patches
    host = "http://trac.macports.org"
    base = "export/57218/trunk/dports/devel/libffi/files"
    { :p0 => "#{host}/#{base}/patch-includedir.diff" }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

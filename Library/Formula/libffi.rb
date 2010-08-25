require 'formula'

class Libffi <Formula
  url 'ftp://sourceware.org/pub/libffi/libffi-3.0.8.tar.gz'
  homepage 'http://sourceware.org/libffi/'
  sha1 'ce44d10c39d9a37479c8777e206cac0f36c48712'

  keg_only :provided_by_osx

  def patches
    host = "http://trac.macports.org"
    base = "export/57218/trunk/dports/devel/libffi/files"
    { :p0 => "#{host}/#{base}/patch-includedir.diff" }
  end

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

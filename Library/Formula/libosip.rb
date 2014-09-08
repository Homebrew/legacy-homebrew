require 'formula'

class Libosip < Formula
  homepage 'http://www.gnu.org/software/osip/'
  url 'http://ftpmirror.gnu.org/osip/libosip2-4.1.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/osip/libosip2-4.1.0.tar.gz'
  sha1 '61459c9052ca2f5e77a6936c9b369e2b0602c080'

  bottle do
    cellar :any
    sha1 "1fab34da8951a2d767a3478553e74fd6beb46bf5" => :mavericks
    sha1 "a5b3fed5a8715d68b28712ed76ea0f0dbdb7f963" => :mountain_lion
    sha1 "c269374768df59fbe962d05322a341abaf418b0b" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

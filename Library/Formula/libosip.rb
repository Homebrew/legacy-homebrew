require 'formula'

class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage 'http://www.gnu.org/software/osip/'
  url 'http://ftpmirror.gnu.org/osip/libosip2-4.1.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/osip/libosip2-4.1.0.tar.gz'
  sha1 '61459c9052ca2f5e77a6936c9b369e2b0602c080'

  bottle do
    cellar :any
    revision 1
    sha1 "390c7708fca1df43b0cec939d724f6095ddc4451" => :yosemite
    sha1 "5b648dbcf493f93c982907329e89f959327f6667" => :mavericks
    sha1 "bf05b7e0f5a1f6c38178e76282b7dd7dba5f3018" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

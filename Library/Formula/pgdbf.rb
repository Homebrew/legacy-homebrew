require 'formula'

class Pgdbf < Formula
  homepage 'http://pgdbf.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.1/pgdbf-0.6.1.tar.xz'
  sha1 '93c9104d92e1ef0c77faf308a6a2976ed0fa2685'

  depends_on 'xz' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

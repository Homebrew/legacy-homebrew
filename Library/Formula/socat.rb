require 'formula'

class Socat < Formula
  homepage 'http://www.dest-unreach.org/socat/'
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.0.tar.bz2'
  md5 'eb563dd00b9d39a49fb62a677fc941fe'

  depends_on 'readline'

  def patches
    # see https://trac.macports.org/ticket/32044; socat devs are aware
    { :p0 => "https://trac.macports.org/export/90442/trunk/dports/sysutils/socat/files/patch-xioexit.c.diff" }
  end

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

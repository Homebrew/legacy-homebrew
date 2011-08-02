require 'formula'

class Libid3tag < Formula
  url 'http://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz'
  md5 'e5808ad997ba32c498803822078748c3'

  def homepage
    Formula.factory('mad').homepage
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

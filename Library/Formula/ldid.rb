require 'formula'

class Ldid < Formula
  url 'http://svn.telesphoreo.org/trunk/data/ldid/ldid-1.0.610.tgz'
  homepage 'http://www.saurik.com/id/8'
  md5 '634c2f8b8a084046883e3793f6580e07'

  def install
    system "g++ -I . -o util/ldid{,.cpp} -x c util/{lookup2,sha1}.c"
    bin.install ["util/ldid"]
  end
end

require "formula"

class MecabKo < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.1.tar.gz"
  version "0.996-ko-0.9.1"
  sha1 "68dad4486d7b74fa5fe7aef0b440e00f17a9e59c"

  # https://bitbucket.org/eunjeon/mecab-ko/pull-request/1/mecab-ko-ipadic-ipadic/diff
  # Below comments out the dicdir path which produces runtime error
  # and mecab-ko requires mecab-ko-dic rather than mecab-ipadic, unlike
  # the original mecab.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


__END__
--- a/mecabrc.in
+++ b/mecabrc.in
@@ -3,7 +3,7 @@
 ;
 ; $Id: mecabrc.in,v 1.3 2006/05/29 15:36:08 taku-ku Exp $;
 ;
-dicdir =  @prefix@/lib/mecab/dic/ipadic
+;dicdir = @prefix@/lib/mecab/dic/ipadic
 
 ; userdic = /home/foo/bar/user.dic

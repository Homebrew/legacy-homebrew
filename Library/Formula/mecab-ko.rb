require "formula"

class MecabKo < Formula
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz"
  version "0.996-ko-0.9.2"
  sha1 "4947620429dea49a69be84efc17736c4875c7180"

  # https://bitbucket.org/eunjeon/mecab-ko/pull-request/1/mecab-ko-ipadic-ipadic/diff
  # Upstream decided not to comment out the dicdir path but replaced
  # 'ipadic' with 'mecab-ko-dic' instead in mecabrc file. 
  # Though the change resolves the error of mecab-ko-dic path by source
  # installation, it still doesn't fit with Homebrew as it's expected
  # installed under /usr/local/ with mecab-ko-dic regardless of version.
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
-dicdir =  @prefix@/lib/mecab/dic/mecab-ko-dic
+;dicdir = @prefix@/lib/mecab/dic/mecab-ko-dic
 
 ; userdic = /home/foo/bar/user.dic

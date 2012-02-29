require 'formula'

class Pdksh < Formula
  url 'http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14.tar.gz'
  homepage 'http://www.cs.mun.ca/~michael/pdksh/'
  md5 '871106b3bd937e1afba9f2ef7c43aef3'

  # sort command that works..
  def patches; DATA; end

  def install
    inreplace "Makefile.in" do |s|
      s.gsub! "$(prefix)/man/man$(manext)", "$(prefix)/share/man/man1"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/siglist.sh b/siglist.sh
index 952edc4..1395092 100755
--- a/siglist.sh
+++ b/siglist.sh
@@ -23,7 +23,7 @@ CPP="${1-cc -E}"
 	{ QwErTy SIG\1 , "\1", "\2" },\
 #endif/') > $in
 $CPP $in  > $out
-sed -n 's/{ QwErTy/{/p' < $out | awk '{print NR, $0}' | sort +2n +0n |
+sed -n 's/{ QwErTy/{/p' < $out | awk '{print NR, $0}' | sort -k 3n -k 1 |
     sed 's/^[0-9]* //' |
     awk 'BEGIN { last=0; nsigs=0; }
 	{


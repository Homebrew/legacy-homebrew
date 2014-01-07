require 'formula'

class LolcatRuby < Formula
  homepage 'https://github.com/busyloop/lolcat'
  url 'https://github.com/busyloop/lolcat/archive/v42.0.99.tar.gz'
  sha1 'acdadd6f41751a908c8c4cf3f0615d64a5b2117b'
  head 'https://github.com/busyloop/lolcat.git'

  conflicts_with 'lolcat-python'

  # Fixed in 091d4b92f0
  if !build.head?
    def patches; DATA end
  end

  def install
    rake "install", "prefix=#{prefix}"
  end
end

__END__
diff -rwu a/lib/lolcat/cat.rb b/lib/lolcat/cat.rb
--- a/lib/lolcat/cat.rb	2011-08-11 18:55:49.000000000 +0300
+++ b/lib/lolcat/cat.rb	2012-08-06 15:17:26.000000000 +0300
@@ -75,8 +75,8 @@
   lolcat            Copy standard input to standard output.
   fortune | lolcat  Display a rainbow cookie.
 
-Report lolcat bugs to <http://www.github.org/busyloop/lolcat/issues>
-lolcat home page: <http://www.github.org/busyloop/lolcat/>
+Report lolcat bugs to <https://github.com/busyloop/lolcat/issues>
+lolcat home page: <https://github.com/busyloop/lolcat/>
 Report lolcat translation bugs to <http://speaklolcat.com/>
 
 FOOTER

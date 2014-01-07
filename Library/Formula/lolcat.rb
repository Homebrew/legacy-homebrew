require 'formula'

class Lolcat < Formula
  homepage 'https://github.com/tehmaze/lolcat'
  url 'https://github.com/tehmaze/lolcat/archive/8f5fc62550.tar.gz'
  sha1 '0f608e1deaebb214df557ced299e664e68e03874'
  version '0.1'
  head 'https://github.com/tehmaze/lolcat.git'

  option "with-ruby", "Compile with ruby version"

  depends_on :python unless build.with? 'ruby'
  depends_on :ruby if build.with? 'ruby'

  if build.with? 'ruby'
	homepage 'https://github.com/busyloop/lolcat'
	url 'https://github.com/busyloop/lolcat/archive/v42.0.99.tar.gz'
	sha1 'acdadd6f41751a908c8c4cf3f0615d64a5b2117b'
	head 'https://github.com/busyloop/lolcat.git'
  end

  # Fixed in 091d4b92f0
  def patches
    DATA unless build.head? and if build.with? 'ruby'
  end

  def install
    if build.with? 'ruby'
    	rake "install", "prefix=#{prefix}"
    else
    	system "python", "setup.py", "install", "--prefix=#{prefix}"
    	bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    end
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

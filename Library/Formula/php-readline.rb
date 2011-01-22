require 'formula'

class PhpReadline <Formula
  url 'http://php.net/distributions/php-5.3.3.tar.bz2'
  homepage 'http://php.net/readline'
  md5 '21ceeeb232813c10283a5ca1b4c87b48'

  def extdir
    lib+"php/extensions/"+File.basename(%x{php-config --extension-dir})
  end

  def install
    cd "ext/readline" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      inreplace "Makefile" do |s|
        s.change_make_var! "EXTENSION_DIR", extdir
      end
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    To enable this extension, add the following line to php.ini:
    extension="#{extdir}/readline.so"
    EOS
  end
end

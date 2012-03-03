require 'formula'

class IgbinaryPhp < Formula
  homepage 'http://pecl.php.net/package/igbinary'
  url 'http://pecl.php.net/get/igbinary-1.1.1.tgz'
  md5 '4ad53115ed7d1d452cbe50b45dcecdf2'

  # php is dependancy because we need igbinary.h 
  depends_on 'php' => :recommended

  def install
    cd "igbinary-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}", "--with-php-config=#{HOMEBREW_PREFIX}/bin/php-config"
      system "make"
      system "make install-headers"
      prefix.install 'modules/igbinary.so'
    end
  end

  def caveats; <<-EOS.undent
    To finish installing igbinary, add the following lines to your php.ini:

    ;-- igbinary.ini --

    ;Load igbinary extension
    extension="#{prefix}/igbinary.so"

    ;Use igbinary as session serializer
    session.serialize_handler=igbinary

    ;Enable or disable compacting of duplicate strings. The default is On.
    igbinary.compact_strings=On

    ;Use igbinary as serializer in APC cache (3.1.7 or later)
    ;apc.serializer=igbinary

    ;-- end igbinary.ini --

    ... and in your php code replace serialize and unserialize function calls
    with ``igbinary_serialize`` and ``igbinary_unserialize``.

    Restart your webserver.
    EOS
  end
end

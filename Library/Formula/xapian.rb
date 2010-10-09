require 'formula'

class XapianBindings <Formula
  url 'http://oligarchy.co.uk/xapian/1.2.3/xapian-bindings-1.2.3.tar.gz'
  homepage 'http://xapian.org'
  sha1 'c320a15be7d1dcf5fc22a46b3ada7cbd75de3823'
end

class Xapian <Formula
  url 'http://oligarchy.co.uk/xapian/1.2.3/xapian-core-1.2.3.tar.gz'
  homepage 'http://xapian.org'
  sha1 'abc0c5d22e6f77c757976719a590580c068ae894'

  def options
    [
      ["--ruby", "Ruby bindings"],
      ["--python", "Python bindings"],
      ["--php", "PHP bindings"],
      ["--java", "Java bindings"],
    ]
  end

  def skip_clean? path
    path.extname == '.la'
  end

  def build_any_bindings?
    ARGV.include? '--ruby' or ARGV.include? '--python' or ARGV.include? '--java' or ARGV.include? '--php'
  end

  def arg_for_lang lang
    (ARGV.include? "--#{lang}") ? "--with-#{lang}" : "--without-#{lang}"
  end

  def install
    ENV.O3 # takes forever otherwise

    system "./configure", "--prefix=#{prefix}", "--disable-assertions",
                          "--disable-dependency-tracking"
    system "make install"

    if build_any_bindings?
      XapianBindings.new.brew do
        args = [
          "XAPIAN_CONFIG=#{bin}/xapian-config",
          "--prefix=#{prefix}",
          "--disable-debug",
          "--disable-dependency-tracking",
          "--without-csharp",
          "--without-tcl"
        ]

        args << arg_for_lang('ruby')
        args << arg_for_lang('python')
        args << arg_for_lang('java')
        args << "MACOX_DEPLOYMENT_TARGET=10.4" if ARGV.include? '--python'

        if ARGV.include? '--php'
          extension_dir = lib+'php/extensions'
          extension_dir.mkpath
          args << "--with-php PHP_EXTENSION_DIR=#{extension_dir}"
        else
          args << "--without-php"
        end

        system "./configure", *args
        system "make install"
      end
    end
  end
end

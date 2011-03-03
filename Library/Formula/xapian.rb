require 'formula'

class XapianBindings <Formula
  url 'http://oligarchy.co.uk/xapian/1.2.4/xapian-bindings-1.2.4.tar.gz'
  homepage 'http://xapian.org'
  sha1 '13611f09cdbca8424c871c79d14c8e75b6547a9c'
end

class Xapian <Formula
  url 'http://oligarchy.co.uk/xapian/1.2.4/xapian-core-1.2.4.tar.gz'
  homepage 'http://xapian.org'
  sha1 'c269e0f711ff4c9423d6301c3f7b949cc85a01b4'

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

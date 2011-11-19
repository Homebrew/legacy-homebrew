require 'formula'

class XapianBindings < Formula
  url 'http://oligarchy.co.uk/xapian/1.2.7/xapian-bindings-1.2.7.tar.gz'
  homepage 'http://xapian.org'
  sha1 '79e9f0b01f1af3440d10d00469dbe248784ffa1c'
end

class Xapian < Formula
  url 'http://oligarchy.co.uk/xapian/1.2.7/xapian-core-1.2.7.tar.gz'
  homepage 'http://xapian.org'
  sha1 'c6c5c5b14d5d64481858ac2b181429a9b8bdc9a1'

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
        args << arg_for_lang('java')

        if ARGV.include? '--python'
          python_lib = lib + "python"
          ENV.append 'PYTHONPATH', python_lib
          python_lib.mkpath
          ENV['OVERRIDE_MACOSX_DEPLOYMENT_TARGET'] = '10.4'
          ENV['PYTHON_LIB'] = "#{python_lib}"
          args << "--with-python"
        else
          args << "--without-python"
        end

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

  def caveats
    s = ""
    if ARGV.include? "--python"
      s += <<-EOS.undent
        The Python bindings won't function until you amend your PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
      EOS
    end
  end
end

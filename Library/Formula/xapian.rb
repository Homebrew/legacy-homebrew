require 'formula'

class XapianBindings < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.8/xapian-bindings-1.2.8.tar.gz'
  sha1 '92cf39c9c00a52a33727e47a1a7aaee2a1b23c2f'
end

class Xapian < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.8/xapian-core-1.2.8.tar.gz'
  sha1 '4bdd3845278812d467b8d0fb73ee27a5be05b2d9'

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
    system "./configure", "--prefix=#{prefix}", "--disable-assertions",
                          "--disable-dependency-tracking"
    system "make install"
    return unless build_any_bindings?

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
        python_lib = lib/which_python/'site-packages'
        python_lib.mkpath
        ENV.append 'PYTHONPATH', python_lib
        ENV['OVERRIDE_MACOSX_DEPLOYMENT_TARGET'] = '10.4'
        ENV['PYTHON_LIB'] = python_lib
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

  def caveats
    if ARGV.include? "--python" then <<-EOS.undent
      The Python bindings won't function until you amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

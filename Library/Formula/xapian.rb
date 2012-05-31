require 'formula'

class XapianBindings < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.10/xapian-bindings-1.2.10.tar.gz'
  sha1 '631c7650ac2ca47f8a72434a06d463da5b7596f4'
end

class Xapian < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.10/xapian-core-1.2.10.tar.gz'
  sha1 '1be1896ab11a3a66c6c0ade962c700d96678116e'

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
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
    return unless build_any_bindings?

    XapianBindings.new.brew do
      args = [
        "XAPIAN_CONFIG=#{bin}/xapian-config",
        "--prefix=#{prefix}",
        "--disable-dependency-tracking",
        "--without-csharp",
        "--without-tcl"
      ]

      args << arg_for_lang('java')

      if ARGV.include? '--ruby'
        ruby_site = lib+'ruby/site_ruby'
        ENV['RUBY_LIB'] = ENV['RUBY_LIB_ARCH'] = ruby_site
        args << '--with-ruby'
      else
        args << '--without-ruby'
      end

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
        args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
      else
        args << "--without-php"
      end
      system "./configure", *args
      system "make install"
    end
  end

  def caveats
    s = ''
    if ARGV.include? '--python'
      s += <<-EOS.undent
        The Python bindings won't function until you amend your PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      EOS
    end
    if ARGV.include? '--ruby'
      s += <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
    return s.empty? ? nil : s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

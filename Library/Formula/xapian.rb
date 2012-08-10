require 'formula'

class XapianBindings < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.12/xapian-bindings-1.2.12.tar.gz'
  sha1 'f75921b43041e6e672821c51fe29dbbaee491791'
end

class Xapian < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.12/xapian-core-1.2.12.tar.gz'
  sha1 '2b96800280fee41eed767289620172f5226c9c4f'

  option "java",   "Java bindings"
  option "php",    "PHP bindings"
  option "python", "Python bindings"
  option "ruby",   "Ruby bindings"

  def skip_clean? path
    path.extname == '.la'
  end

  def build_any_bindings?
    build.include? 'ruby' or build.include? 'python' or build.include? 'java' or build.include? 'php'
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    return unless build_any_bindings?

    XapianBindings.new.brew do
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
        XAPIAN_CONFIG=#{bin}/xapian-config
        --without-csharp
        --without-tcl
      ]

      if build.include? 'java'
        args << '--with-java'
      else
        args << '--without-java'
      end

      if build.include? 'ruby'
        ruby_site = lib+'ruby/site_ruby'
        ENV['RUBY_LIB'] = ENV['RUBY_LIB_ARCH'] = ruby_site
        args << '--with-ruby'
      else
        args << '--without-ruby'
      end

      if build.include? 'python'
        python_lib = lib/which_python/'site-packages'
        python_lib.mkpath
        ENV.append 'PYTHONPATH', python_lib
        ENV['OVERRIDE_MACOSX_DEPLOYMENT_TARGET'] = '10.4'
        ENV['PYTHON_LIB'] = python_lib
        args << "--with-python"
      else
        args << "--without-python"
      end

      if build.include? 'php'
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
    if build.include? 'python'
      s += <<-EOS.undent
        The Python bindings won't function until you amend your PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

      EOS
    end
    if build.include? 'ruby'
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

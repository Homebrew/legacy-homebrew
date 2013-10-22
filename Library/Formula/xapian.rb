require 'formula'

class Xapian < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.13/xapian-core-1.2.13.tar.gz'
  sha1 'ae5edc64671c5f32a3a24abf8cc3028cb56f6c6b'

  option "java",   "Java bindings"
  option "php",    "PHP bindings"
  option "ruby",   "Ruby bindings"

  depends_on :python => :optional

  resource 'bindings' do
    url 'http://oligarchy.co.uk/xapian/1.2.13/xapian-bindings-1.2.13.tar.gz'
    sha1 '0cffc6ae2df295d2f8bc052831ed225e60236e92'
  end

  skip_clean :la

  def build_any_bindings?
    build.include? 'ruby' or build.with? 'python' or build.include? 'java' or build.include? 'php'
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    return unless build_any_bindings?

    resource('bindings').stage do
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

      if build.with? 'python'
        ENV['PYTHON_LIB'] = python.site_packages
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
    s += python.standard_caveats if python
    if build.include? 'ruby'
      s += <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
    return s.empty? ? nil : s
  end

end

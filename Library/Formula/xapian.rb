require 'formula'

class Xapian < Formula
  homepage 'http://xapian.org'
  url 'http://oligarchy.co.uk/xapian/1.2.19/xapian-core-1.2.19.tar.xz'
  sha1 'a8679cd0f708e32f2ec76bcdc198cd9fa2e1d65e'

  bottle do
    sha1 "51971954b89b767f45c0cdbec9b3bc39c4704d2e" => :yosemite
    sha1 "90cc658d5639598783c165938edce758f44657f4" => :mavericks
    sha1 "fd032717423f8440865e9b6b3e82b3d1b70f8fad" => :mountain_lion
  end

  option "java",   "Java bindings"
  option "php",    "PHP bindings"
  option "ruby",   "Ruby bindings"

  depends_on :python => :optional

  resource 'bindings' do
    url 'http://oligarchy.co.uk/xapian/1.2.19/xapian-bindings-1.2.19.tar.xz'
    sha1 '5aa4a5f8d2f8dbc604f7e785a087668543ede9a1'
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
        (lib+'python2.7/site-packages').mkpath
        ENV['PYTHON_LIB'] = lib+'python2.7/site-packages'
        # configure looks for python2 and system python doesn't install one
        ENV["PYTHON"] = which "python"
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
    if build.include? 'ruby'
      <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end
end

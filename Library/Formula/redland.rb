require 'formula'

class Redland < Formula
  homepage 'http://librdf.org/'
  url 'http://download.librdf.org/source/redland-1.0.16.tar.gz'
  sha1 '0dc3d65bee6d580cae84ed261720b5b4e6b1f856'

  option 'with-php', 'Build with php support'
  option 'with-ruby', 'Build with ruby support'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'unixodbc'
  depends_on 'sqlite' => :recommended
  depends_on 'berkeley-db' => :optional
  depends_on :python => :optional

  resource 'bindings' do
    url 'http://download.librdf.org/source/redland-bindings-1.0.16.1.tar.gz'
    sha1 '98c20b64cf5e99cbf29fcb84490e73e2a828213a'
  end

  fails_with :llvm do
    build 2334
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-mysql=no
    ]

    if build.with? 'sqlite'
      args << "--with-sqlite=yes"
    else
      args << "--with-sqlite=no"
    end

    if build.with? 'berkeley-db'
      args << "--with-bdb=#{Formula["berkeley-db"].opt_prefix}"
    else
      args << "--with-bdb=no"
    end

    system "./configure", *args
    system "make install"

    if %w{php python ruby}.any? { |lang| build.with? lang }
      resource('bindings').stage do
        args = %W[
          --disable-debug
          --disable-dependency-tracking
          --prefix=#{prefix}
        ]

        if build.with? 'php'
          args << "--with-php"
          args << "--with-php-linking=dylib"
        end

        if build.with? 'ruby'
          `ruby --version` =~ /ruby (\d\.\d).\d \(.*\) \[(.*)\]/
          ruby_install_dir = lib + 'ruby/site_ruby/' + $1
          ruby_arch_install_dir = ruby_install_dir + $2
          ruby_install_dir.mkpath
          ruby_arch_install_dir.mkpath
          args << "--with-ruby"
          args << "--with-ruby-install-dir=#{ruby_install_dir}"
          args << "--with-ruby-arch-install-dir=#{ruby_arch_install_dir}"
        end

        if build.with? 'python'
          ENV['PYTHON_LIB'] = lib/'python2.7/site-packages'
          args << "--with-python"
        end

        ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

        system "./configure", *args

        if build.with? 'php'
          php_extension_dir = lib + 'php/extensions'
          php_extension_dir.mkpath
          inreplace 'php/Makefile' do |s|
            s.change_make_var! 'PHP_EXTENSION_DIR', php_extension_dir
            s.change_make_var! 'phpdir', php_extension_dir
          end
        end

        system "make install"
      end
    end
  end

  def caveats
    s = ''

    if build.with? 'php'
      s += <<-EOS.undent
        You may need to add the following line to php.ini:
          extension="#{HOMEBREW_PREFIX}/lib/php/extensions/redland.dylib"
      EOS
    end

    if build.with? 'ruby'
      s += <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      EOS
    end

    return s.empty? ? nil : s
  end
end

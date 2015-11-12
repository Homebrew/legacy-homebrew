class Redland < Formula
  desc "RDF Library"
  homepage "http://librdf.org/"
  url "http://download.librdf.org/source/redland-1.0.17.tar.gz"
  sha256 "de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681"

  bottle do
    sha1 "5f4840ede53c1f9ab9c7387355fc682be3a524b7" => :yosemite
    sha1 "db4d3fdde92412bafe55e19def76b3447168595c" => :mavericks
    sha1 "523752a1bd434159e361f66a7a72b45412d30a7a" => :mountain_lion
  end

  revision 1

  option "with-php", "Build with php support"
  option "with-ruby", "Build with ruby support"

  depends_on "pkg-config" => :build
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "unixodbc"
  depends_on "sqlite" => :recommended
  depends_on "berkeley-db" => :optional
  depends_on :python => :optional

  resource "bindings" do
    url "http://download.librdf.org/source/redland-bindings-1.0.17.1.tar.gz"
    sha256 "ff72b587ab55f09daf81799cb3f9d263708fad5df7a5458f0c28566a2563b7f5"
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

    if build.with? "sqlite"
      args << "--with-sqlite=yes"
    else
      args << "--with-sqlite=no"
    end

    if build.with? "berkeley-db"
      args << "--with-bdb=#{Formula["berkeley-db"].opt_prefix}"
    else
      args << "--with-bdb=no"
    end

    system "./configure", *args
    system "make", "install"

    if %w[php python ruby].any? { |lang| build.with? lang }
      resource("bindings").stage do
        args = %W[
          --disable-debug
          --disable-dependency-tracking
          --prefix=#{prefix}
        ]

        if build.with? "php"
          args << "--with-php"
          args << "--with-php-linking=dylib"
        end

        if build.with? "ruby"
          `ruby --version` =~ /ruby (\d\.\d).\d \(.*\) \[(.*)\]/
          ruby_install_dir = lib + "ruby/site_ruby/" + $1
          ruby_arch_install_dir = ruby_install_dir + $2
          ruby_install_dir.mkpath
          ruby_arch_install_dir.mkpath
          args << "--with-ruby"
          args << "--with-ruby-install-dir=#{ruby_install_dir}"
          args << "--with-ruby-arch-install-dir=#{ruby_arch_install_dir}"
        end

        if build.with? "python"
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"
          args << "--with-python"
        end

        ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

        system "./configure", *args

        if build.with? "php"
          php_extension_dir = lib + "php/extensions"
          php_extension_dir.mkpath
          inreplace "php/Makefile" do |s|
            s.change_make_var! "PHP_EXTENSION_DIR", php_extension_dir
            s.change_make_var! "phpdir", php_extension_dir
          end
        end

        system "make", "install"
      end
    end
  end

  def caveats
    s = ""

    if build.with? "php"
      s += <<-EOS.undent
        You may need to add the following line to php.ini:
          extension="#{HOMEBREW_PREFIX}/lib/php/extensions/redland.dylib"
      EOS
    end

    if build.with? "ruby"
      s += <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby
      EOS
    end

    s.empty? ? nil : s
  end
end

class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.22/xapian-core-1.2.22.tar.xz"
  sha256 "269b87ca3faf79d444e8bb82ed58a96f1955008d7702f9966dec68608588527f"

  bottle do
    cellar :any
    sha256 "b267353a70be8ff9891d3d4d24d95eb31d5153ca67ec8abecb62b65f18e9af90" => :el_capitan
    sha256 "97538ad4b81b4166eac4bb266ff49c6d4e0db702d674596bdfe606ddc58ec646" => :yosemite
    sha256 "996605fec788d00abcc5c3d2be02f8cc4f06142329188a516e33236ea5a49ba3" => :mavericks
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"

  depends_on :python => :optional

  resource "bindings" do
    url "http://oligarchy.co.uk/xapian/1.2.22/xapian-bindings-1.2.22.tar.xz"
    sha256 "b15ca7984980a1d2aedd3378648ef5f3889cb39a047bac1522a8e5d04f0a8557"
  end

  skip_clean :la

  def install
    build_binds = build.with?("ruby") || build.with?("python") || build.with?("java") || build.with?("php")

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build_binds
      resource("bindings").stage do
        args = %W[
          --disable-dependency-tracking
          --prefix=#{prefix}
          XAPIAN_CONFIG=#{bin}/xapian-config
          --without-csharp
          --without-tcl
        ]

        if build.with? "java"
          args << "--with-java"
        else
          args << "--without-java"
        end

        if build.with? "ruby"
          ruby_site = lib/"ruby/site_ruby"
          ENV["RUBY_LIB"] = ENV["RUBY_LIB_ARCH"] = ruby_site
          args << "--with-ruby"
        else
          args << "--without-ruby"
        end

        if build.with? "python"
          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"
          # configure looks for python2 and system python doesn't install one
          ENV["PYTHON"] = which "python"
          args << "--with-python"
        else
          args << "--without-python"
        end

        if build.with? "php"
          extension_dir = lib/"php/extensions"
          extension_dir.mkpath
          args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
        else
          args << "--without-php"
        end

        system "./configure", *args
        system "make", "install"
      end
    end
  end

  def caveats
    if build.with? "ruby"
      <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end

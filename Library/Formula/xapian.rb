class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.19/xapian-core-1.2.19.tar.xz"
  sha256 "4a78260388ff1b042f0ab5d18afdd524a530ae609690d0339990ddc147a54785"

  bottle do
    cellar :any
    revision 1
    sha256 "223966e50beed39b091f1e0e9c99113420211d99c7a959efcc44a66507506f89" => :el_capitan
    sha256 "6ffe866abf19269399d42d4f77f6251b2fa99abfa6ea0c3ccedf1b554f6bd26b" => :yosemite
    sha256 "2bffd7ca22b71a06537138c43b3a0dc010d2af5bb3bd26b190d57cfb998e4434" => :mavericks
  end

  option "java",   "Java bindings"
  option "php",    "PHP bindings"
  option "ruby",   "Ruby bindings"

  depends_on :python => :optional

  resource "bindings" do
    url "http://oligarchy.co.uk/xapian/1.2.19/xapian-bindings-1.2.19.tar.xz"
    sha256 "3b9434c6144cc347783175c92829f304e86919bbbd44f51b7b4a7148960cde17"
  end

  skip_clean :la

  def build_any_bindings?
    build.include?("ruby") || build.with?("python") || build.include?("java") || build.include?("php")
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    return unless build_any_bindings?

    resource("bindings").stage do
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
        XAPIAN_CONFIG=#{bin}/xapian-config
        --without-csharp
        --without-tcl
      ]

      if build.include? "java"
        args << "--with-java"
      else
        args << "--without-java"
      end

      if build.include? "ruby"
        ruby_site = lib+"ruby/site_ruby"
        ENV["RUBY_LIB"] = ENV["RUBY_LIB_ARCH"] = ruby_site
        args << "--with-ruby"
      else
        args << "--without-ruby"
      end

      if build.with? "python"
        (lib+"python2.7/site-packages").mkpath
        ENV["PYTHON_LIB"] = lib+"python2.7/site-packages"
        # configure looks for python2 and system python doesn't install one
        ENV["PYTHON"] = which "python"
        args << "--with-python"
      else
        args << "--without-python"
      end

      if build.include? "php"
        extension_dir = lib+"php/extensions"
        extension_dir.mkpath
        args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
      else
        args << "--without-php"
      end
      system "./configure", *args
      system "make", "install"
    end
  end

  def caveats
    if build.include? "ruby"
      <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end
end

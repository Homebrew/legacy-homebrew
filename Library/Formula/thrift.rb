require "formula"

class Thrift < Formula
  homepage "http://thrift.apache.org"

  stable do
    url "http://archive.apache.org/dist/thrift/0.9.2/thrift-0.9.2.tar.gz"
    sha1 "02f78b158da795ea89a26ce41964fbe562cc4235"

    # Apply any necessary patches (none currently required)
    [
      # Example patch:
      #
      # Apply THRIFT-2201 fix from master to 0.9.1 branch (required for clang to compile with C++11 support)
      # %w{836d95f9f00be73c6936d407977796181d1a506c 4bc8c19c51f3d9f30799251a810dd1ca63c4bf1e},
    ].each do |name, sha|
      patch do
        url "https://git-wip-us.apache.org/repos/asf?p=thrift.git;a=patch;h=#{name}"
        sha1 sha
      end
    end
  end

  bottle do
    cellar :any
    sha1 "e25bf36e90de292f4c78306232c5da7aeb80f64d" => :yosemite
    sha1 "0d5d03141d555eac1b374a33068a259ca313accc" => :mavericks
    sha1 "4556b6cac2a5b751d17a4b899574bf7c569d06b7" => :mountain_lion
  end

  head do
    url "https://git-wip-us.apache.org/repos/asf/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install PHP binding"

  depends_on "boost"
  depends_on "openssl"
  depends_on "libevent" => :optional
  depends_on :python => :optional
  depends_on "bison" => :build

  def install
    system "./bootstrap.sh" unless build.stable?

    exclusions = ["--without-ruby", "--disable-tests", "--without-php_extension"]

    exclusions << "--without-python" if build.without? "python"
    exclusions << "--without-haskell" if build.without? "haskell"
    exclusions << "--without-java" if build.without? "java"
    exclusions << "--without-perl" if build.without? "perl"
    exclusions << "--without-php" if build.without? "php"
    exclusions << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    To install Ruby binding:
      gem install thrift

    To install PHP extension for e.g. PHP 5.5:
      brew install homebrew/php/php55-thrift
    EOS
  end
end

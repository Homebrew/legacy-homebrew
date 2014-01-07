require 'formula'

class Thrift < Formula
  homepage 'http://thrift.apache.org'
  url 'http://archive.apache.org/dist/thrift/0.9.1/thrift-0.9.1.tar.gz'
  sha1 'dc54a54f8dc706ffddcd3e8c6cd5301c931af1cc'

  head do
    url 'https://git-wip-us.apache.org/repos/asf/thrift.git', :branch => "master"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'pkg-config' => :build
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  depends_on 'boost'
  depends_on :python => :optional

  # Includes are fixed in the upstream. Please remove this patch in the next version > 0.9.0
  def patches
    [
      # Fix issue with C++11 and reserved-user-defined-literal
      "https://gist.github.com/duedal/7156317/raw/a7edf1de9d092ef5b0a4f3fc3c048e1985248d36/thrifty.patch",
      # Apply THRIFT-2201 fix from master to 0.9.1 branch (required for clang to compile with C++11 support)
      "https://git-wip-us.apache.org/repos/asf?p=thrift.git;a=patch;h=836d95f9f00be73c6936d407977796181d1a506c",
      # Tutorial includes both boost and std, so shared_ptr is ambigous with C++11 support enabled
      "https://gist.github.com/duedal/7156317/raw/9fec9ed82d160f027730ec1790852135dd37ef9f/cpp-tutorial.patch"
    ]
  end

  def install
    system "./bootstrap.sh" if build.head?

    exclusions = ["--without-ruby"]
    exclusions << "--without-tests"

    exclusions << "--without-python" unless build.with? "python"
    exclusions << "--without-haskell" unless build.include? "with-haskell"
    exclusions << "--without-java" unless build.include? "with-java"
    exclusions << "--without-perl" unless build.include? "with-perl"
    exclusions << "--without-php" unless build.include? "with-php"
    exclusions << "--without-erlang" unless build.include? "with-erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    ENV["PY_PREFIX"] = prefix  # So python bindins don't install to /usr!

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    To install Ruby bindings:
      gem install thrift

    To install PHP bindings:
      export PHP_PREFIX=/path/to/homebrew/thrift/0.9.1/php
      export PHP_CONFIG_PREFIX=/path/to/homebrew/thrift/0.9.1/php_extensions
      brew install thrift --with-php

    EOS
  end
end

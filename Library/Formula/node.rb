# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.10.36/node-v0.10.36.tar.gz"
  sha256 "b9d7d1d0294bce46686b13a05da6fc5b1e7743b597544aa888e8e64a9f178c81"

  conflicts_with "iojs", :because => "node and iojs both install a binary/link named node"

  devel do
    url "https://nodejs.org/dist/v0.11.15/node-v0.11.15.tar.gz"
    sha256 "e613d274baa4c99a0518038192491433f7877493a66d8505af263f6310991d01"

    depends_on "pkg-config" => :build
    depends_on "icu4c" => :optional
    depends_on "openssl" => :optional
    # Install "npm" :recomended ??? How do I do that?
  end

  head do
    url "https://github.com/joyent/node.git", :branch => "v0.12"

    depends_on "pkg-config" => :build
    depends_on "icu4c"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugger hooks"

  depends_on :python => :build

  # Once we kill off SSLv3 in our OpenSSL consider making our OpenSSL
  # an optional dep across the whole range of Node releases.

  fails_with :llvm do
    build 2326
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--without-ssl2" << "--without-ssl3" if build.stable?

    if build.head?
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_lib}/pkgconfig"
      args << "--with-intl=system-icu"
    end

    if build.devel?
      if build.with? "icu4c"
        ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_lib}/pkgconfig"
        args << "--with-intl=system-icu"
      end

      if build.with? "openssl"
        args << "--shared-openssl"
      else
        args << "--without-ssl2" << "--without-ssl3"
      end
    end

    system "./configure", *args
    system "make", "install"

  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end

class Ice < Formula
  desc "A comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.6.0.tar.gz"
  sha256 "77933580cdc7fade0ebfce517935819e9eef5fc6b9e3f4143b07404daf54e25e"

  bottle do
    revision 1
    sha256 "8c9d7b09e8b6b19126ada33f6b7cea1a7837993b90203fe6f6dde2bf4bef3460" => :yosemite
    sha256 "87a5dd2311296bea03889062d4f20ad76a7de31382a42409bfb933d8e66052eb" => :mavericks
  end

  depends_on "mcpp"
  depends_on :java  => ["1.7", :optional]
  depends_on :macos => :mavericks

  resource "berkeley-db" do
    url "http://download.oracle.com/berkeley-db/db-5.3.28.NC.tar.gz"
    sha256 "76a25560d9e52a198d37a31440fd07632b5f1f8f9f2b6d5438f4bc3e7c9013ef"
  end

  def install
    resource("berkeley-db").stage do
      # Fix build under Xcode 4.6
      # Double-underscore names are reserved, and __atomic_compare_exchange is now
      # a built-in, so rename this to something non-conflicting.
      inreplace "src/dbinc/atomic.h" do |s|
        s.gsub! "__atomic_compare_exchange", "__atomic_compare_exchange_db"
      end

      # BerkeleyDB dislikes parallel builds
      ENV.deparallelize
      args = %W[
        --disable-debug
        --prefix=#{libexec}
        --mandir=#{libexec}/man
        --enable-cxx
      ]

      args << "--enable-java" if build.with? "java"

      # BerkeleyDB requires you to build everything from the build_unix subdirectory
      cd "build_unix" do
        system "../dist/configure", *args
        system "make", "install"
      end
    end

    inreplace "cpp/src/slice2js/Makefile", /install:/, "dontinstall:"

    if build.with? "java"
      inreplace "java/src/IceGridGUI/build.gradle", "${DESTDIR}${binDir}/${appName}.app",  "${prefix}/${appName}.app"
    else
      inreplace "cpp/src/slice2java/Makefile", /install:/, "dontinstall:"
      inreplace "cpp/src/slice2freezej/Makefile", /install:/, "dontinstall:"
    end

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")
    ENV.delete("USE_BIN_DIST")
    ENV.delete("CPPFLAGS")
    ENV.O2

    args = %W[
      prefix=#{prefix}
      embedded_runpath_prefix=#{prefix}
      USR_DIR_INSTALL=yes
      OPTIMIZE=yes
      DB_HOME=#{libexec}
    ]

    cd "cpp" do
      system "make", "install", *args
    end

    cd "objective-c" do
      system "make", "install", *args
    end

    if build.with? "java"
      cd "java" do
        system "make", "install", *args
      end
    end

    cd "php" do
      args << "install_phpdir=#{share}/php"
      args << "install_libdir=#{lib}/php/extensions"
      system "make", "install", *args
    end
  end
end

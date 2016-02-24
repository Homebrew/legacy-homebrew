class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.6.1-el_capitan.tar.gz"
  sha256 "4a348ba24daceb7694bc23ee91994e2653c5d869918e44b2b1f0d49a360e93fb"
  version "3.6.1"

  bottle do
    sha256 "d6de8a22389eda0100589d1abfe1ed341b3cd2b768a5372adc9035cd2ca3ba21" => :el_capitan
    sha256 "5becc3d56ac408859947ce7485087370dede96019f0d951960f60a65fd076311" => :yosemite
    sha256 "65537de34ac6fe8e5691e24c758b1511be8c2a6087acc0df3b8e85ad18a99fcb" => :mavericks
  end

  option "with-java", "Build Ice for Java and the IceGrid Admin app"

  depends_on "mcpp"
  depends_on :java => [ "1.7+", :optional]
  depends_on :macos => :mavericks

  resource "berkeley-db" do
    url "https://zeroc.com/download/homebrew/db-5.3.28.NC.brew.tar.gz"
    sha256 "8ac3014578ff9c80a823a7a8464a377281db0e12f7831f72cef1fd36cd506b94"
  end

  def install
    resource("berkeley-db").stage do
      # BerkeleyDB dislikes parallel builds
      ENV.deparallelize
      args = %W[
        --disable-debug
        --prefix=#{libexec}
        --mandir=#{libexec}/man
        --enable-cxx
      ]

      if build.with? "java"
        args << "--enable-java"

        # @externl from ZeroC submitted this patch to Oracle through an internal ticket system
        inreplace "dist/Makefile.in", "@JAVACFLAGS@",  "@JAVACFLAGS@ -source 1.7 -target 1.7"
      end

      # BerkeleyDB requires you to build everything from the build_unix subdirectory
      cd "build_unix" do
        system "../dist/configure", *args
        system "make", "install"
      end
    end

    inreplace "cpp/src/slice2js/Makefile", /install:/, "dontinstall:"

    if build.with? "java"
      inreplace "java/src/IceGridGUI/build.gradle", "${DESTDIR}${binDir}/${appName}.app",  "${prefix}/${appName}.app"
    end

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")
    ENV.delete("USE_BIN_DIST")
    ENV.delete("CPPFLAGS")
    ENV.O2

    args = %W[
      prefix=#{prefix}
      USR_DIR_INSTALL=yes
      OPTIMIZE=yes
      DB_HOME=#{libexec}
      MCPP_HOME=#{Formula["mcpp"].opt_prefix}
    ]

    cd "cpp" do
      system "make", "install", *args
    end

    # Do not set this for C++ as we need to use various slice compilers to build ice. This will be
    # unnecessary in the next release
    args << "embedded_runpath_prefix=#{prefix}"

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

  test do
    (testpath/"Hello.ice").write <<-EOS.undent
      module Test {
        interface Hello {
          void sayHello();
        };
      };
    EOS
    (testpath/"Test.cpp").write <<-EOS.undent
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello {
      public:
        virtual void sayHello(const Ice::Current&) {}
      };

      int main(int argc, char* argv[]) {
        Ice::CommunicatorPtr communicator;
        communicator = Ice::initialize(argc, argv);
        Ice::ObjectAdapterPtr adapter =
            communicator->createObjectAdapterWithEndpoints("Hello", "default -h localhost -p 10000");
        adapter->add(new HelloI, communicator->stringToIdentity("hello"));
        adapter->activate();
        communicator->destroy();
        return 0;
      }
    EOS
    system "#{bin}/slice2cpp", "Hello.ice"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Test.cpp"
    system "xcrun", "clang++", "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce", "-lIceUtil"
    system "./test", "--Ice.InitPlugins=0"
  end
end

class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.6.0.tar.gz"
  sha256 "77933580cdc7fade0ebfce517935819e9eef5fc6b9e3f4143b07404daf54e25e"

  bottle do
    revision 2
    sha256 "afee4ec276259a24243ce08c848c10c930fecbc3bbd086ca1eec2b9e7863384f" => :yosemite
    sha256 "0fd42d37aaac81da90b098a6138eac4ade95ddfc6adc5709d0e42f8e91e67c70" => :mavericks
  end

  option "with-java", "Build Ice for Java and the IceGrid Admin app"

  depends_on "mcpp"
  depends_on :java => :optional
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

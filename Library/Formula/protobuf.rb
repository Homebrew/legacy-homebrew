require "formula"

class OldOrNoDateutilUnlessGoogleApputils < Requirement
  # https://github.com/Homebrew/homebrew/issues/32571
  # https://code.google.com/p/google-apputils-python/issues/detail?id=6
  fatal true

  satisfy(:build_env => false) {
    if can_import("dateutil") && !can_import("google.apputils")
      dateutil_version < Version.new("2.0")
    else
      true
    end
  }

  def message; <<-EOS.undent
    The protobuf Python bindings depend on the google-apputils Python library,
    which requires a version of python-dateutil less than 2.0.

    You have python-dateutil version #{dateutil_version} installed in:
      #{Pathname.new(`python -c "import dateutil; print(dateutil.__file__)"`.chomp).dirname}

    Please run:
      pip uninstall python-dateutil && pip install "python-dateutil<2"
    EOS
  end

  def can_import pymodule
    quiet_system "python", "-c", "import #{pymodule}"
  end

  def dateutil_version
    Version.new(`python -c "import dateutil; print(dateutil.__version__)"`.chomp)
  end
end

class Protobuf < Formula
  homepage "https://github.com/google/protobuf/"
  url 'https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.bz2'
  sha1 '6421ee86d8fb4e39f21f56991daa892a3e8d314b'

  bottle do
    cellar :any
    revision 1
    sha1 "fa7019a4ee16a4bdf0c653dc3fd932dc5a7e1e3b" => :yosemite
    sha1 "f3ba19bdabe4994c7c69d05897a52be8b13117bf" => :mavericks
    sha1 "9239ad264a7327cc90d1d3ddb26a27a4de10527f" => :mountain_lion
  end

  # this will double the build time approximately if enabled
  option "with-check", "Run build-time check"

  option :universal
  option :cxx11

  depends_on :python => :optional
  depends_on OldOrNoDateutilUnlessGoogleApputils if build.with? "python"

  fails_with :llvm do
    build 2334
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # http://code.google.com/p/protobuf/source/browse/trunk/configure.ac#61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

    # Install editor support and examples
    doc.install %w( editors examples )

    if build.with? "python"
      chdir "python" do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        system "python", "setup.py", "build"
        system "python", "setup.py", "install", "--cpp_implementation", "--prefix=#{prefix}",
               "--single-version-externally-managed", "--record=installed.txt"
      end
    end
  end

  test do
    def testdata; <<-EOS.undent
      package test;
      message TestCase {
        required string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      EOS
    end
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--cpp_out=."
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end
end

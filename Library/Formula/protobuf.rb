class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/google/protobuf/"

  stable do
    url "https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.bz2"
    sha256 "ee445612d544d885ae240ffbcbf9267faa9f593b7b101f21d58beceb92661910"

    # Fixes the unexpected identifier error when compiling software against protobuf:
    # https://github.com/google/protobuf/issues/549
    patch :p1, :DATA
  end

  bottle do
    revision 4
    sha256 "86b6d300868bb5e8579370e99808faa95303a4cd7878833163e083586d16be90" => :el_capitan
    sha256 "af85f70b1f44156475d6235192760715484594c108f8d42e0d3dde2a8c38e5ca" => :yosemite
    sha256 "9e07fe0d49634dbebfb7f55a68573f1ca2bb2cf5f6ab3bffc3fc451323900965" => :mavericks
  end

  devel do
    url "https://github.com/google/protobuf/archive/v3.0.0-beta-2.tar.gz"
    sha256 "be224d07ce87f12e362cff3df02851107bf92a4e4604349b1d7a4b1f0c3bfd86"
    version "3.0.0-beta-2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/google/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # this will double the build time approximately if enabled
  option "with-test", "Run build-time check"
  deprecated_option "with-check" => "with-test"

  option :universal
  option :cxx11

  option "without-python", "Build without python support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2334
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.1.tar.bz2"
    sha256 "a9f62b12e28f11c732ad8e255721a9c7ab905f9479759491bc1f1e91de548d0f"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.10.tar.bz2"
    sha256 "387f968fde793b142865802916561839f5591d8b4b14c941125eb0fca7e4e58d"
  end

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  resource "google-apputils" do
    url "https://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/google/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    system "./autogen.sh" if build.devel? || build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    if build.with? "python"
      # google-apputils is a build-time dependency
      ENV.prepend_create_path "PYTHONPATH", buildpath/"homebrew/lib/python2.7/site-packages"
      %w[six python-dateutil pytz python-gflags google-apputils].each do |package|
        resource(package).stage do
          system "python", *Language::Python.setup_install_args(buildpath/"homebrew")
        end
      end
      # google is a namespace package and .pth files aren't processed from
      # PYTHONPATH
      touch buildpath/"homebrew/lib/python2.7/site-packages/google/__init__.py"
      chdir "python" do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        args = Language::Python.setup_install_args libexec
        args << "--cpp_implementation"
        system "python", *args
      end
      site_packages = "lib/python2.7/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
    end
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end

  test do
    testdata = if devel?
      <<-EOS.undent
        syntax = "proto3";
        package test;
        message TestCase {
          string name = 4;
        }
        message Test {
          repeated TestCase case = 1;
        }
        EOS
    else
      <<-EOS.undent
        package test;
        message TestCase {
          required string name = 4;
        }
        message Test {
          repeated TestCase case = 1;
        }
        EOS
    end
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    system "python", "-c", "import google.protobuf" if build.with? "python"
  end
end

__END__
diff --git a/src/google/protobuf/descriptor.h b/src/google/protobuf/descriptor.h
index 67afc77..504d5fe 100644
--- a/src/google/protobuf/descriptor.h
+++ b/src/google/protobuf/descriptor.h
@@ -59,6 +59,9 @@
 #include <vector>
 #include <google/protobuf/stubs/common.h>

+#ifdef TYPE_BOOL
+#undef TYPE_BOOL
+#endif

 namespace google {
 namespace protobuf {

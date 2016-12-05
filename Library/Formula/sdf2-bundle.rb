class Sdf2Bundle < Formula
  desc "parser and parser generator for syntax definition formalism (SDF2)"
  homepage "http://www.program-transformation.org/Sdf/SdfBundle"
  url "http://releases.strategoxt.org/strategoxt-0.17/sdf2-bundle/sdf2-bundle-2.4pre212034-37nm9z7p/sdf2-bundle-2.4.tar.gz"
  sha256 "2ec83151173378f48a3326e905d11049d094bf9f0c7cff781bc2fce0f3afbc11"

  depends_on "aterm"
  depends_on "pkg-config" => :build

  conflicts_with "sdf", :because => "Both install multiple common libraries and includes"

  fails_with :clang do
    build 700
    cause <<-EOS.undent
      `clang -dynamiclib  -o .libs/libErrorAPI.dylib ...` fails with error message:
      libErrorAPI.dylib
      Undefined symbols for architecture x86_64:
        "_ERR_isErrorError", referenced from:
            _ERR_fdisplayError in libErrorAPI_la-display.o
            _ERR_liftError in libErrorAPI_la-lift.o

      and more undefined symbols in other object files.
      EOS
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end

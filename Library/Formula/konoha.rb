class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"

  bottle do
    sha256 "85ae184ec6d34407588f31830e5669ee0a69be8d36ce2d9ef7074eb01b8831bf" => :el_capitan
    sha256 "0be611a0289cff989e4da04177788c91345a579a187833710967d6f0bd8d11c3" => :yosemite
    sha256 "e35edb76cab240a9c35e8727027d745cf7835099fa68c6622159b00d50736802" => :mavericks
  end

  head do
    url "https://github.com/konoha-project/konoha3.git"

    depends_on "openssl"
  end

  option "with-test", "Verify the build with make test (May currently fail)"

  deprecated_option "tests" => "with-test"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx]
  depends_on "pcre"
  depends_on "json-c"
  depends_on "sqlite"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on :python if MacOS.version <= :snow_leopard # for python glue code

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      # `make test` currently fails. Reported upstream:
      # https://github.com/konoha-project/konoha3/issues/438
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write "System.p(\"Hello World!\");"
    output = shell_output("#{bin}/konoha #{testpath}/test")
    assert_match "(test:1) Hello World!", output
  end
end

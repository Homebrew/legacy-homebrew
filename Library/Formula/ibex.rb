class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "http://www.ibex-lib.org/sites/default/files/ibex-2.1.16.tar.gz"
  sha256 "d92ff32f14d27ad7b390ae693beb311b58cf6babccac85bbdaa5f5d0b8648845"

  option "with-java", "Build Java bindings for Choco solver."
  depends_on :java => ["1.8+", :optional]
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  def install
    if build.with? "java"
      system "./waf", "configure",
        "--with-jni",
        "--prefix=#{prefix}"
    else
      system "./waf", "configure",
        "--enable-shared",
        "--prefix=#{prefix}"
    end
    system "./waf", "install"

    # copy and compile examples and benchmark for the test
    share.install "examples"
    share.install "benchs"
    cxxflags = "-frounding-math -ffloat-store -I#{include} -I#{include}/ibex"
    libflags = "-L#{lib} -libex -lprim -lClp -lCoinUtils -lm"
    cd "#{share}/examples"
    system "make", "defaultsolver",
      "LIBS=#{libflags}",
      "CXXFLAGS=#{cxxflags}"
  end

  test do
    cp_r "#{share}/examples/.", "#{testpath}"
    cp "#{share}/benchs/cyclohexan3D.bch", "#{testpath}"
    system "./defaultsolver", "cyclohexan3D.bch", "1e-05", "10"
  end
end

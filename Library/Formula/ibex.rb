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
    args = ["--prefix=#{prefix}"]

    if build.with? "java"
      args << "--with-jni"
    else
      args << "--enable-shared"
    end

    system "./waf", "configure", *args
    system "./waf", "install"

    cd "examples" do
      cxxflags = "-frounding-math -ffloat-store -I#{include} -I#{include}/ibex"
      libflags = "-L#{lib} -libex -lprim -lClp -lCoinUtils -lm"
      system "make", "defaultsolver", "LIBS=#{libflags}", "CXXFLAGS=#{cxxflags}"
    end

    pkgshare.install %w[examples benchs]
  end

  test do
    cp_r "#{pkgshare}/examples/.", testpath
    cp "#{pkgshare}/benchs/cyclohexan3D.bch", testpath
    system "./defaultsolver", "cyclohexan3D.bch", "1e-05", "10"
  end
end

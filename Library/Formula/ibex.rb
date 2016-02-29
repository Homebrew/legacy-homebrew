class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "http://www.ibex-lib.org/sites/default/files/ibex-2.1.16.tar.gz"
  sha256 "d92ff32f14d27ad7b390ae693beb311b58cf6babccac85bbdaa5f5d0b8648845"

  bottle do
    cellar :any
    sha256 "21744850c087156a1ced058b7c4ca6bc8521d0f29b97929b211f544f9284e3c9" => :el_capitan
    sha256 "8f3820e87fea2799f4789bf956803dadab7789e2c51c29567e339db4e08473b7" => :yosemite
    sha256 "51288d9af477d65a26f8f37bee74e07913df0e77be6bbc979758a8486a1d6fd3" => :mavericks
    sha256 "41327b6a0da9b8b2ed888c3c2c33d5f6ff061ea13eceb4b9e8b6e660049d624d" => :mountain_lion
  end

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

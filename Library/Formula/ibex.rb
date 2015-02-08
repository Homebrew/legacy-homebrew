class Ibex < Formula
  homepage "http://www.ibex-lib.org/"
  url "http://www.ibex-lib.org/sites/default/files/ibex-2.1.12.tgz"
  sha1 "9ba6f72309a732cc6347e1f6f30c7b6581ff20c2"

  option "with-java", "Build Java bindings for Choco solver."
  if build.with? "java"
    depends_on :java => "1.8+"
    depends_on "pkg-config" => :build
  end
  depends_on "bison" => :build
  depends_on "flex" => :build

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
    share.install "examples"
    share.install "benchs"
  end

  test do
    cp_r "#{share}/examples/.", "#{testpath}"
    system "make", "defaultsolver"
    cp "#{share}/benchs/cyclohexan3D.bch", "#{testpath}"
    system "./defaultsolver", "cyclohexan3D.bch", "1e-05", "10"
  end
end

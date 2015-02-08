class Ibex < Formula
  homepage "http://www.ibex-lib.org/"
  url "http://www.ibex-lib.org/sites/default/files/ibex-2.1.12.tgz"
  version "2.1.12"
  sha1 "9ba6f72309a732cc6347e1f6f30c7b6581ff20c2"

  option "with-java", "Build Java bindings for Choco solver."
  if build.with? "java"
      depends_on :java => "1.8+"
      depends_on 'pkg-config' => :build
  end
  depends_on 'gcc' => :build
  depends_on :python => :build
  depends_on 'bison'
  depends_on 'flex'

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
    prefix.install "examples"
    prefix.install "benchs"
  end

  test do
    system "cp", "-R", "#{prefix}/examples/", "#{testpath}"
    system "make defaultsolver"
    system "cp", "#{prefix}/benchs/cyclohexan3D.bch", "#{testpath}"
    system "./defaultsolver", "cyclohexan3D.bch", "1e-05", "10"
  end
end

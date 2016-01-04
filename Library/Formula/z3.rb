class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.1.tar.gz"
  sha256 "50967cca12c5c6e1612d0ccf8b6ebf5f99840a783d6cf5216336a2b59c37c0ce"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "ea169ccefdbebdd17213b4fab603dce2029b03bde0b62fa98920cbaf431d4771" => :el_capitan
    sha256 "e8f726245f283d43efe68f2516ebf1fc62fd2ab486a850befc0c388ef9f5c1ed" => :yosemite
    sha256 "2c67f6d604e3b478bac87e223891f3252a8f29a048564a91a8ea57f6c3b9a8ba" => :mavericks
  end

  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "z3: --with-python3 must be specified when using --without-python"
  end
  depends_on :java => :optional
  depends_on "ocaml" => :optional

  def install
    inreplace "scripts/mk_util.py", "dist-packages", "site-packages"

    # Installing  JARs to "lib" can cause conflicts between packages. Therefore install the jar to libexec
    inreplace "scripts/mk_util.py", "out.write('\\t@cp %s.jar %s.jar\\n' % (self.package_name, os.path.join('$(PREFIX)', 'lib', self.package_name)))", "out.write('\\t@cp %s.jar %s.jar\\n' % (self.package_name, os.path.join('$(PREFIX)', 'libexec', self.package_name)))"
    libexec.mkpath

    Language::Python.each_python(build) do |python, _|
      args = ["--prefix=#{prefix}"]
      args << "-j" if build.with? "java"
      args << "--ml" if build.with? "ocaml"
      system python, "scripts/mk_make.py", *args
      cd "build" do
        system "make"
        system "make", "install"

        (lib/"ocaml").install Dir["api/ml/*"] if build.with? "ocaml"
      end
    end

    pkgshare.install "examples"
  end

  def caveats
    s = ""
    if build.with? "java"
      s += <<-EOS.undent

        Java bindings were installed into #{libexec}/com.microsoft.z3.jar and #{lib}/z3java.dylib.
        To use these, set the classpath and java.library.path accordingly.
        Alternatively, you may need to link the Java bindings into the Java Extensions folder:
          sudo mkdir -p /Library/Java/Extensions
          sudo ln -s #{lib}/libz3java.dylib #{libexec}/com.microsoft.z3.jar /Library/Java/Extensions
      EOS
    end
    s
  end

  test do
    # Test C bindings
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    assert_match(/Z3 #{version}/, shell_output("./test"))

    # Test z3 binary with SMT2 input
    field_test = testpath/"test_field.smt"
    field_test.write <<-EOS.undent
      (declare-const a Real)
      (declare-const b Real)
      (declare-const c Real)

      ; Verify the axioms of the field of Real numbers
      (assert (= (+ (+ a b) c) (+ a (+ b c))))        ; Associativity of addition
      (assert (= (+ a b) (+ b a)))                    ; Commutativity of addition
      (assert (= (+ (- 0 a) a) 0))                    ; Existence of an inverse element of addition
      (assert (= (+ 0 a) a))                          ; Existence of a neutral element of addition
      (assert (= (* (* a b) c) (* a (* b c))))        ; Associativity of multiplication
      (assert (= (* a b) (* b a)))                    ; Commutativity of multiplication
      (assert (= (* (/ 1 a) a) 0))                    ; Existence of an inverse element of addition
      (assert (= (* 1 a) a))                          ; Existence of a neutral element of addition
      (assert (= (* a (+ b c)) (+ (* a b) (* a c))))  ; Left-distributive property
      (assert (= (* (+ a b) c) (+ (* a c) (* b c))))  ; Right-distributive property

      (check-sat)
    EOS
    field_sat = shell_output("#{bin}/z3 -smt2 #{field_test}")
    assert_equal "sat\n", field_sat

    # Test if a simple unsatisfiable test fails
    unsat_test = testpath/"unsat_test.smt"
    unsat_test.write <<-EOS.undent
      (assert (= 42 23))
      (check-sat)
    EOS
    unsat = shell_output("#{bin}/z3 -smt2 #{unsat_test}")
    assert_equal "unsat\n", unsat

    if build.with? "python"
      assert_equal "#{version}\n", shell_output('python -c "import z3; print z3.get_version_string()"')
    end
  end
end

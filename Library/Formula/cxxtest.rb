class Cxxtest < Formula
  desc "CxxTest Unit Testing Framework"
  homepage "http://cxxtest.com"
  url "https://github.com/CxxTest/cxxtest/archive/4.3.tar.gz"
  sha256 "356d0f4810e8eb5c344147a0cca50fc0d84122c286e7644b61cb365c2ee22083"

  bottle do
    cellar :any
    sha256 "adf5f38f015e2446c0b73afe5e0d4782a172f42d9cad5a6415f0714775fb7501" => :yosemite
    sha256 "64309902d052b985325fd1372f76802f52434a005966bd0388241c2af6da83ff" => :mavericks
    sha256 "e894f5ede73f1b13545c4db334c8e9ac1408fd43ca1316a48b38fc1d727d6cfb" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"

    cd "./python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    include.install "cxxtest"
    doc.install Dir["doc/*"]
  end

  test do
    testfile = testpath/"MyTestSuite1.h"
    testfile.write <<-EOS.undent
      #include <cxxtest/TestSuite.h>

      class MyTestSuite1 : public CxxTest::TestSuite {
      public:
          void testAddition(void) {
              TS_ASSERT(1 + 1 > 1);
              TS_ASSERT_EQUALS(1 + 1, 2);
          }
      };
    EOS

    system bin/"cxxtestgen", "--error-printer", "-o", testpath/"runner.cpp", testfile
    system ENV.cxx, "-o", testpath/"runner", testpath/"runner.cpp"
    system testpath/"runner"
  end
end

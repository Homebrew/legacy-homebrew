class Verilator < Formula
  desc "Verilog simulator"
  homepage "http://www.veripool.org/wiki/verilator"
  url "http://www.veripool.org/ftp/verilator-3.872.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/v/verilator/verilator_3.872.orig.tar.gz"
  sha256 "d00b7a4838bea9cf2d80d9693729f225c2369ab679f8f8fc4f5153e3f7517084"

  bottle do
    sha256 "a161f22b400f96c8d01a77a17fc16c70884f4a866933a7d261cbc5097d10cc31" => :yosemite
    sha256 "9765a1ac7fc8b9064ca558f0bfa99c6058ef772ee9c3105ab5e474a55ac9488b" => :mavericks
    sha256 "05e9e4cbb0d860356425f251616db680fe827679bb6dd3b2acd6e6118336984c" => :mountain_lion
  end

  head do
    url "http://git.veripool.org/git/verilator", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # Needs a newer flex on Lion (and presumably below)
  # http://www.veripool.org/issues/720-Verilator-verilator-not-building-on-Mac-OS-X-Lion-10-7-
  depends_on "flex" if MacOS.version <= :lion

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<-EOS.undent
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system "/usr/bin/perl", bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<-EOS.undent
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end

class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.0.tar.gz"
  sha256 "179f09afbafb951bea28c9001b06ed8b9b2e54181092d48e343cb20f436b1185"

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<-EOS.undent
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp
  end
end

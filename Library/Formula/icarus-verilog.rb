class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.7.tar.gz"
  sha256 "7a5e72e17bfb4c3a59264d8f3cc4e70a7c49c1307173348fdd44e079388e7454"

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # Separate steps, as install does not depend on compile properly
    system "make"
    system "make", "installdirs"
    system "make", "install"
  end
end

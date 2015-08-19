class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/downloads/matricks/bam/bam-0.4.0.tar.gz"
  sha256 "5e4e4920b4d265da582f66774e9b1ec8ddfbe75ddc028fba86c12f686ea18db3"

  head "https://github.com/matricks/bam.git"

  bottle do
    cellar :any
    sha1 "7ec0b273b35f7e543cc6a1810a14e14062f81639" => :yosemite
    sha1 "6b531fb8df899d603f93262f87cfdcb8001b8436" => :mavericks
    sha1 "dce2512abc5625827a16becba635941b007c16dd" => :mountain_lion
  end

  def install
    system "./make_unix.sh"
    bin.install "bam"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) { printf("hello\\n"); return 0; }
    EOS

    (testpath/"bam.lua").write <<-EOS.undent
      settings = NewSettings()
      objs = Compile(settings, Collect("*.c"))
      exe = Link(settings, "hello", objs)
    EOS

    system "bam", "-v"
    assert_equal "hello\n", shell_output("./hello")
  end
end

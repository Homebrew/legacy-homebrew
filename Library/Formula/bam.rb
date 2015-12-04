class Bam < Formula
  desc "Build system that uses Lua to describe the build process"
  homepage "https://matricks.github.io/bam/"
  url "https://github.com/downloads/matricks/bam/bam-0.4.0.tar.gz"
  sha256 "5e4e4920b4d265da582f66774e9b1ec8ddfbe75ddc028fba86c12f686ea18db3"

  head "https://github.com/matricks/bam.git"

  bottle do
    cellar :any
    sha256 "832033a89e90b4152690ac9738af8db839f322e79b7169bc8bdf1a866707cf22" => :yosemite
    sha256 "ba4ee90c3fc9001761bf2c09906c5c3df66c6175d7b763fa3527c3c512c2f2d5" => :mavericks
    sha256 "73362b46dfe24dc3d6c4bb59bdb9d0403ec717054428f78bc9dd32a93343a187" => :mountain_lion
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

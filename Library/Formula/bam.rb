class Bam < Formula
  homepage "http://matricks.github.io/bam/"
  url "https://github.com/downloads/matricks/bam/bam-0.4.0.tar.gz"
  sha1 "c0f32ff9272d5552e02a9d68fbdd72106437ee69"

  head "https://github.com/matricks/bam.git"

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

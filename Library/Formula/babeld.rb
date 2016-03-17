class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/"
  url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/babeld-1.7.1.tar.gz"
  sha256 "2c955e7d4ad971da1e860e5cedbaf1dd79903468ff6488b3f67102b2a8d087b6"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cb902685dea1e9a14fbce621faf5a1d1bed0680fbaa964bb3a64eb595360a89" => :el_capitan
    sha256 "980282deb71194aa092f3e0b706bc4305a8e9224943e0adeeadb4d06278b6af8" => :yosemite
    sha256 "b69f241357333d7cfb90d419cc5305c08d92a87110971e8ad164716a92ad3129" => :mavericks
    sha256 "e4baaabd8690aa60b4874eb606ce62f5de0d7c378e8c0eccc409724b898fb212" => :mountain_lion
  end

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    expected = <<-EOS.undent
      Couldn't tweak forwarding knob.: Operation not permitted
      kernel_setup failed.
    EOS
    assert_equal expected, (testpath/"test.log").read
  end
end

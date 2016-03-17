class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/"
  url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/babeld-1.7.1.tar.gz"
  sha256 "2c955e7d4ad971da1e860e5cedbaf1dd79903468ff6488b3f67102b2a8d087b6"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f563a08d747b49704c8e5199d47a49cec054c47223588bf93813a6308e8a91d" => :el_capitan
    sha256 "2e27e11276bff50b27a19dd876ac0a1ec436a0390c37477ce9dd1c6b28b89dcc" => :yosemite
    sha256 "60da868795bffd2c11a3aa9b194fc6f5a27e8e09539b67908db9e71cc933b9b6" => :mavericks
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

class Ack < Formula
  homepage "http://beyondgrep.com/"
  url "http://beyondgrep.com/ack-2.14-single-file"
  sha1 "49c43603420521e18659ce3c50778a4894dd4a5f"
  version "2.14"

  def install
    bin.install "ack-#{version}-single-file" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}/ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end

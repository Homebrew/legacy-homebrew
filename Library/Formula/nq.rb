class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.1.tar.gz"
  sha256 "e0962a5e6a2cbf799bba7a79af22c40d21e5a80605df42c8bba37d3d8efb1793"

  head "https://github.com/chneukirchen/nq.git"

  depends_on :macos => :yosemite

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match /exited with status 0/, shell_output("#{bin}/fq -a")
    assert File.exist?("TEST")
  end
end

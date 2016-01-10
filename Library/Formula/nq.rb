class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.1.tar.gz"
  sha256 "e0962a5e6a2cbf799bba7a79af22c40d21e5a80605df42c8bba37d3d8efb1793"

  head "https://github.com/chneukirchen/nq.git"

  bottle do
    cellar :any
    sha256 "1d6d53c0c53a230a600ee3be346c07625d7deffd2c134c46eb61d429d4392722" => :yosemite
  end

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

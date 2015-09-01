class Nq < Formula
  desc "Unix command line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.1.tar.gz"
  version "0.1"
  sha256 "e0962a5e6a2cbf799bba7a79af22c40d21e5a80605df42c8bba37d3d8efb1793"

  def install
    system "make", "PREFIX=#{prefix}", "clean", "install"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match /exited with status 0/, `#{bin}/fq -a`
    assert File.exist?("TEST")
  end
end

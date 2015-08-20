class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/v1.1.0.tar.gz"
  sha256 "829f0815f0721453833942c8da28bf02845bfef9f844373d9ed67d5017a54588"
  head "https://github.com/pipeseroni/pipes.sh.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pipes.sh -v").strip.split[-1]
  end
end

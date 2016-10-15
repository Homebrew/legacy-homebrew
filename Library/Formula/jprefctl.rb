class Jprefctl < Formula
  desc "A command line Java preferences editor"
  homepage "https://github.com/canbican/jprefctl"
  url "https://github.com/canbican/jprefctl/releases/download/0.9.3/jprefctl-0.9.3-brew.zip"
  sha256 "fda9f6e38f19f43a8a0a3c363c3409f93191368eac01b1b513e8094b0e666c53"
  depends_on :java => "1.7"
  def install
    bin.install "jprefctl"
    libexec.install "jprefctl-0.9.3.jar"
    man8.install "jprefctl.8"
    prefix.install "LICENSE"
  end
  test do
    system "#{bin}/jprefctl","-a"
  end
end

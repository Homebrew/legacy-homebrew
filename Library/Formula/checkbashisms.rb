class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.15.8.tar.xz"
  sha256 "7d2df363f9a725096d281321e0c2a41e1613e645955c3956a78bd91715bc87ff"

  head "lp:ubuntu/devscripts", :using => :bzr

  bottle do
    cellar :any
    sha1 "ba3d65481d041cc28b3f1c2a0887a1c2a08694d0" => :yosemite
    sha1 "0a2f8609c179a3096683645b64410dc3388245e6" => :mavericks
    sha1 "973505a805eadf37740db75a646e168b8c6545c7" => :mountain_lion
    sha1 "81691ff80d98176deefb878972ae419567326d12" => :lion
  end

  def install
    inreplace "scripts/checkbashisms.pl", "###VERSION###", "#{version}ubuntu1"
    bin.install "scripts/checkbashisms.pl" => "checkbashisms"
    man1.install "scripts/checkbashisms.1"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/bin/sh

      if [[ "home == brew" ]]; then
        echo "dog"
      fi
    EOS
    expected = <<-EOS.undent
      (alternative test command ([[ foo ]] should be [ foo ])):
    EOS
    assert_match expected, shell_output("#{bin}/checkbashisms #{testpath}/test.sh 2>&1", 1)
  end
end

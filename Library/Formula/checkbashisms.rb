class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.15.8.tar.xz"
  sha256 "7d2df363f9a725096d281321e0c2a41e1613e645955c3956a78bd91715bc87ff"

  head "lp:ubuntu/devscripts", :using => :bzr

  bottle :unneeded

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

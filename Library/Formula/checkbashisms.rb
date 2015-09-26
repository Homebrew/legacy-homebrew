class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.15.8.tar.xz"
  sha256 "7d2df363f9a725096d281321e0c2a41e1613e645955c3956a78bd91715bc87ff"

  head "lp:ubuntu/devscripts", :using => :bzr

  bottle do
    cellar :any
    sha256 "b4a455ac40a27e2478900bebece0c6538271bc4b6c033f24fefec9ab50e5208d" => :yosemite
    sha256 "ea49cbf4cb6af2f8a8dfd82be51639f1836016b934cdf392457faf17c90b45c3" => :mavericks
    sha256 "86d58dda562653996957b8d3fdf454890f36258a2b1e290a237259473cdcd09a" => :mountain_lion
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

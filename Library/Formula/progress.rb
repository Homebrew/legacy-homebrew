class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.9.tar.gz"
  sha256 "63e1834ec114ccc1de3d11722131b5975e475bfd72711d457e21ddd7fd16b6bd"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "966124c6d66ed029895b1f2f3a9548e9d100287676cc31630e7179eec0009728" => :el_capitan
    sha256 "003f1a3ba9356bfd68149d9ae6f57e4e81bb0d7def7dc9d4419338275f2e6af1" => :yosemite
    sha256 "9bb9bb6343e1d886f98e9ab94f2dc9391c800151bae49b27f87397319c69d730" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/zero", "of=/dev/null", "bs=100000", "count=1000000"
    end
    sleep 1
    begin
      assert_match(/dd/, shell_output("#{bin}/progress"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

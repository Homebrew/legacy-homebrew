class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin645.tar.gz"
  version "6.4.5"
  sha256 "44081282eb63cd9df763ebbcf8bad19dbeefecbebf8ac2cc090ea92e2ab71875"

  bottle do
    cellar :any_skip_relocation
    sha256 "675449c646388047b03b50d7fa825654fa056e857d50e8729875765990acb240" => :el_capitan
    sha256 "6d88fb1d345bcb7f49cb8624e02b4c1895d09f383c502fb62a6631df8037b836" => :yosemite
    sha256 "974442a06ab42b2ba3dd16818a1bd201cc064fa6995e133b196d643b03d4eda7" => :mavericks
  end

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    cd "Src#{version}" do
      system "make"
      bin.install "spin"
    end

    bin.install "iSpin/ispin.tcl" => "ispin"
    man1.install "Man/spin.1"
  end

  test do
    (testpath/"test.pml").write <<-EOS.undent
      mtype = { ruby, python };
      mtype = { golang, rust };
      mtype language = ruby;

      active proctype P() {
        do
        :: if
          :: language == ruby -> language = golang
          :: language == python -> language = rust
          fi;
          printf("language is %e", language)
        od
      }
    EOS
    output = shell_output("#{bin}/spin #{testpath}/test.pml")
    assert_match /language is golang/, output
  end
end

require "language/go"

class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0440b77998204934baafcd3d607c1fee407a3116b4b0b23dd3b91dd0a29ebe04" => :el_capitan
    sha256 "b2c058bcdab37bc890e03b843fcb07f500d0ccce5157c94cb75ab0bc0f629f71" => :yosemite
    sha256 "a65fc487274d29dc68d8dba8cc85318606dae4c55aa64446fc61e76c5d82ed60" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/Tonkpils/").mkpath
    ln_s buildpath, buildpath/"src/github.com/Tonkpils/snag"

    system "go", "build", "-o", bin/"snag", "./src/github.com/Tonkpils/snag"
  end

  test do
    (testpath/".snag.yml").write <<-EOS.undent
      build:
        - touch #{testpath}/snagged
      verbose: true
    EOS
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    File.exist? testpath/"snagged"
  end
end

require "language/go"

class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18a6d589a0b416ee502a8dacd6f919959d25cc08d9bbaad152fdade4c72634dc" => :el_capitan
    sha256 "00edba081c3a56f6cda3a4fc5bb1125d8ce93a8239c3cae89346b1893df12025" => :yosemite
    sha256 "df63529c6ec2ff4f38f0fb7900687b9362ce710a13013d4bac4bb9cdea5190da" => :mavericks
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

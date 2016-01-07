require "language/go"

class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad.git",
    :tag => "v0.2.3",
    :revision => "2977583c78e622ab257ed323ec1bc6cd8b8120dd"

  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59cdb99e953fef055974153941688fc53c0552dd6595d104904013f4e108f00b" => :el_capitan
    sha256 "1958ec999a7ac82b9883b37ef667eaae9dff6c4ed22d5a1298605f8c5426c3d9" => :yosemite
    sha256 "34d09de2484828cb72d53a98f8ea4f5fd7d77eb26ceacef9d21c1fffaf29ac1d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
      :revision => "ce433bf86e4d05eeae4276aefc462ec825c2a4f5"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/nomad").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/hashicorp/nomad" do
      system "make", "bootstrap"
      system "make", "dev"
      bin.install "bin/nomad"
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 10
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end

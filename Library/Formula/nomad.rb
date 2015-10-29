require "language/go"

class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad.git",
    :tag => "v0.1.0",
    :revision => "520763c0715ee88b6571db840e62fab186d7fe59"

  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59e7bc4a26dde1329cfa4a9f6402cda6581ebecf7df3ac272a3a8f0a7feafcf7" => :el_capitan
    sha256 "82038862d6930db7cfebd3caddfc49d4d212670dc6e6f4bd9e3503ba17e86bc7" => :yosemite
    sha256 "b7337b785c022cb651cd85d5cecdc16398a0bd2e8cc87edf42d5dc61ad6dbb63" => :mavericks
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

    # explicit install of shirou/gopsutil/cpu to work around error message:
    #   cannot load DWARF output from $WORK/github.com/shirou/gopsutil/cpu/_obj//_cgo_.o:
    #   decoding dwarf section info at offset 0x0: too short
    cd gopath/"src/github.com/shirou/gopsutil/cpu" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/nomad" do
      system "make"
      bin.install "bin/nomad"
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 5
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end

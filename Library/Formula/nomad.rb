require "language/go"

class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad.git",
    :tag => "v0.3.0",
    :revision => "8c27f155500ed22c1660a218177f2cc9b0639c25"

  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77fcdff1a7e23906bb2aa655b60061a6ed4c6e53c904e9f22ffbe30f5413b597" => :el_capitan
    sha256 "d765b9ee7cebe273d292d6903c2bcc579044912308dec01462127f5c3bc9c803" => :yosemite
    sha256 "fef71e5ac35486d05a967691e99a67bf84aa3c917c1a28b718333937bd971bb3" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/nomad").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/ugorji/go/codec/codecgen" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/nomad" do
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

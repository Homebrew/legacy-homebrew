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
    url "https://github.com/ugorji/go/archive/c062049c1793b01a3cc3fe786108edabbaf7756b.tar.gz"
    sha256 "933c1d57a8085fe421480efffcc643fb25f74e33d4936af9797d895333945e47"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox/archive/39862d88e853ecc97f45e91c1cdcb1b312c51eaa.tar.gz"
    sha256 "c884282ebb143a037975418d0c3a73843d5147f73af6723d19b6177d369f4fcc"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan/archive/87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz"
    sha256 "71c117246bb1d4d78ad5c3bc5d301942bcebaae5b1e35da1ad7851ceac71a675"
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

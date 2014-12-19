require "formula"

class GoInstalled < Requirement
  fatal true
  default_formula "go"
  satisfy { which "go" }

  def message
    "Go is required to use gpm."
  end
end

class Gpm < Formula
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.3.1.tar.gz"
  sha1 "e29a009aeddad05d08a23c3694bedad7602dbe7a"

  bottle do
    cellar :any
    sha1 "d07f2a511b3111d069dfc74ecbaccf7059e67c61" => :mavericks
    sha1 "94975efcfb696ff95e37a3b845ed16ff9d00ff82" => :mountain_lion
    sha1 "2623227176179dbdb5e828b93d590b432c4ab503" => :lion
  end

  depends_on GoInstalled

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    Pathname("Godeps").write "github.com/pote/gpm-testing-package v6.1"

    ENV["GOPATH"] = testpath
    system bin/"gpm", "install"

    Pathname("go_code.go").write <<-EOS.undent
      package main

      import (
              "fmt"
              "github.com/pote/gpm-testing-package"
      )

      func main() {
              fmt.Print(gpm_testing_package.Version())
      }
    EOS

    out = `go run go_code.go`
    assert_equal "v6.1", out
    assert_equal 0, $?.exitstatus
  end
end

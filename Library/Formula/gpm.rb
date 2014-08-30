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
  url "https://github.com/pote/gpm/archive/v1.2.3.tar.gz"
  sha1 "dc616876b874f01e7eaec75ef34f13e43df7ae91"

  bottle do
    cellar :any
    revision 1
    sha1 "09e9738ddacf8fc954517e684904e65b7f71c204" => :mavericks
    sha1 "bb2bebe26115752d276c46122bca4bf69aa84058" => :mountain_lion
    sha1 "d5079472808bb62a4d0864548f3f640e4ccb72cb" => :lion
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

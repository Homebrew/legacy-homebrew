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
  url "https://github.com/pote/gpm/archive/v1.2.0.tar.gz"
  sha1 "9d676d76c7ee9c21a404286b528323db12adb1c8"

  bottle do
    cellar :any
    sha1 "95096e58bdf1fac62b758f1d7b4f45b2a6fc8586" => :mavericks
    sha1 "1ac597052f23d3f82a0fd47b14a2f81343da6c3e" => :mountain_lion
    sha1 "feb12d15984f48f4499fd59ca7810ec95ad5a1e5" => :lion
  end

  depends_on GoInstalled

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    Pathname("Godeps").write "github.com/pote/gpm-testing-package v6.1"

    ENV["GOPATH"] = testpath
    system "gpm", "install"

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
    `go run go_code.go` == "v6.1"
  end
end

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
    sha1 "be4a9a7e9a5e920d04c145e3fcb55580607a0f53" => :mavericks
    sha1 "551c3f73f109eddf6fa1938cfa2fbe05088c0dad" => :mountain_lion
    sha1 "433716c37294d5380affb56371d6677fe6e2e58b" => :lion
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

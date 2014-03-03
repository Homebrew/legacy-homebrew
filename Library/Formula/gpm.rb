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
  url "https://github.com/pote/gpm/archive/v1.0.1.tar.gz"
  sha1 "f2e74eb20479bff9ddbb05369d19f82290a7b744"

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

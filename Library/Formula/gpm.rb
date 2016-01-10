class GoRequirement < Requirement
  fatal true
  default_formula "go"
  satisfy { which "go" }

  def message
    "Go is required to use gpm."
  end
end

class Gpm < Formula
  desc "Barebones dependency manager for Go"
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.3.2.tar.gz"
  sha256 "c79b10c9f13d9cc79f2dcf08323daac86b9bb50cf7b84924ebeb28e98334c0ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "baef6fd02013c452c8d74ac109de4191823ebc4fb957e184ffd620b4d71b87d4" => :el_capitan
    sha256 "8694759b92b7a01d234ab3369391dcd65fb5558a15d678d5c73cb957eb7573d4" => :yosemite
    sha256 "c4fb2b9cea8b116d1c6145619797bff68cd97c8be9f14dcd9c99cd6bf6e24deb" => :mavericks
    sha256 "0efe4d9fbd5207cff83169a571c7ddb815b434e99b206fc9989e9a309436451f" => :mountain_lion
  end

  depends_on GoRequirement

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

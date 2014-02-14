require "formula"

class Gpm < Formula
  homepage "https://github.com/pote/gpm"
  url "https://github.com/pote/gpm/archive/v1.0.1.tar.gz"
  sha1 "f2e74eb20479bff9ddbb05369d19f82290a7b744"

  depends_on 'go' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    File.open('Godeps', 'w') do |file|
      file.write("github.com/pote/gpm-testing-package v6.1")
    end

    ## Runs the install action in gpm with $GOPATH pointing to
    ## homebrew's temporary test path.
    system({ "GOPATH" => testpath }, "gpm", "install")

    ## Create a Go executable file that imports and uses the test package
    ## and execute it.
    go_code <<EOF
package main

import (
	"fmt"
	"github.com/pote/gpm-testing-package"
)

func main() {
	fmt.Println(gpm_testing_package.Version())
}
EOF

  File.open('go_code.go', 'w') { |file| file.write(go_code) }

  system("go", "run", "go_code.go")
  end
end

require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  head 'https://go.googlesource.com/go', :using => :git
  url 'https://storage.googleapis.com/golang/go1.4.src.tar.gz'
  version '1.4'
  sha1 '6a7d9bd90550ae1e164d7803b3e945dc8309252b'

  bottle do
    sha1 "33aa691a93a3c9aa40334e3ce6daa49420696fe4" => :yosemite
    sha1 "9fa24700a5187fd8272178bd731fb3f9aa485188" => :mavericks
    sha1 "359fe25e6755c2362d619c01363a7f80ec59efca" => :mountain_lion
  end

  option 'cross-compile-all', "Build the cross-compilers and runtime support for all supported platforms"
  option 'cross-compile-common', "Build the cross-compilers and runtime support for darwin, linux and windows"
  option 'without-cgo', "Build without cgo"

  def install
    # host platform (darwin) must come last in the targets list
    if build.include? 'cross-compile-all'
      targets = [
        ['linux',   ['386', 'amd64', 'arm']],
        ['freebsd', ['386', 'amd64', 'arm']],
        ['netbsd',  ['386', 'amd64', 'arm']],
        ['openbsd', ['386', 'amd64']],
        ['windows', ['386', 'amd64']],
        ['dragonfly', ['386', 'amd64']],
        ['plan9',   ['386', 'amd64']],
        ['solaris', ['amd64']],
        ['darwin',  ['386', 'amd64']],
      ]
    elsif build.include? 'cross-compile-common'
      targets = [
        ['linux',   ['386', 'amd64', 'arm']],
        ['windows', ['386', 'amd64']],
        ['darwin',  ['386', 'amd64']],
      ]
    else
      targets = [['darwin', ['']]]
    end

    # The version check is due to:
    # http://codereview.appspot.com/5654068
    (buildpath/'VERSION').write('default') if build.head?

    cd 'src' do
      targets.each do |os, archs|
        cgo_enabled = os == 'darwin' && build.with?('cgo') ? "1" : "0"
        archs.each do |arch|
          ENV['GOROOT_FINAL'] = libexec
          ENV['GOOS']         = os
          ENV['GOARCH']       = arch
          ENV['CGO_ENABLED']  = cgo_enabled
          system "./make.bash", "--no-clean"
        end
      end
    end

    (buildpath/'pkg/obj').rmtree

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/go*"]
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      http://golang.org/doc/code.html#GOPATH

    `go vet` and `go doc` are now part of the go.tools sub repo:
      http://golang.org/doc/go1.2#go_tools_godoc

    To get `go vet` and `go doc` run:
      go get golang.org/x/tools/cmd/vet
      go get golang.org/x/tools/cmd/godoc

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/'hello.go').write <<-EOS.undent
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello World")
    }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", `#{bin}/go run hello.go`
  end
end

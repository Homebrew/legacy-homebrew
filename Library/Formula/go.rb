require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  url 'https://go.googlecode.com/files/go1.1.2.src.tar.gz'
  version '1.1.2'
  sha1 'f5ab02bbfb0281b6c19520f44f7bc26f9da563fb'

  head 'https://go.googlecode.com/hg/'

  skip_clean 'bin'

  option 'cross-compile-all', "Build the cross-compilers and runtime support for all supported platforms"
  option 'cross-compile-common', "Build the cross-compilers and runtime support for darwin, linux and windows"
  option 'with-cgo', "Build with cgo"

  # the cgo module cannot build with clang
  # NOTE it is ridiculous that we put this stuff in the class
  # definition, it needs to be in a pre-install test function!
  if build.with? 'cgo'
    fails_with :clang do
      cause "clang: error: no such file or directory: 'libgcc.a'"
    end
  end

  # Upstream patch for a switch statement that causes a clang error
  # Should be in the next release.
  # http://code.google.com/p/go/source/detail?r=000ecca1178d67c9b482d3fb0b6a1bc4aeef2472&path=/src/cmd/ld/lib.c
  def patches; DATA; end

  def install
    # install the completion scripts
    bash_completion.install 'misc/bash/go' => 'go-completion.bash'
    zsh_completion.install 'misc/zsh/go' => 'go'

    if build.include? 'cross-compile-all'
      targets = [
        ['linux',   ['386', 'amd64', 'arm'], { :cgo => false }],
        ['freebsd', ['386', 'amd64'],        { :cgo => false }],
        ['netbsd',  ['386', 'amd64'],        { :cgo => false }],
        ['openbsd', ['386', 'amd64'],        { :cgo => false }],

        ['windows', ['386', 'amd64'],        { :cgo => false }],

        # Host platform (darwin/amd64) must always come last
        ['darwin',  ['386', 'amd64'],        { :cgo => build.with?('cgo')  }],
      ]
    elsif build.include? 'cross-compile-common'
      targets = [
        ['linux',   ['386', 'amd64', 'arm'], { :cgo => false }],
        ['windows', ['386', 'amd64'],        { :cgo => false }],

        # Host platform (darwin/amd64) must always come last
        ['darwin',  ['386', 'amd64'],        { :cgo => build.with?('cgo')  }],
      ]
    else
      targets = [
        ['darwin', [''], { :cgo => build.with?('cgo') }]
      ]
    end

    # The version check is due to:
    # http://codereview.appspot.com/5654068
    (buildpath/'VERSION').write('default') if build.head?

    cd 'src' do
      targets.each do |os, archs, opts|
        archs.each do |arch|
          ENV['GOROOT_FINAL'] = libexec
          ENV['GOOS']         = os
          ENV['GOARCH']       = arch
          ENV['CGO_ENABLED']  = opts[:cgo] ? "1" : "0"
          system "./make.bash", "--no-clean"
        end
      end
    end

    (buildpath/'pkg/obj').rmtree

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The go get command no longer allows $GOROOT as
    the default destination in Go 1.1 when downloading package source.
    To use the go get command, a valid $GOPATH is now required.

    As a result of the previous change, the go get command will also fail
    when $GOPATH and $GOROOT are set to the same value.

    More information here: http://golang.org/doc/code.html#GOPATH

    FYI: We probably didn't build the cgo module because it doesn't build with
    clang.
    EOS
    # NOTE I would have the cgo caveat only show if we didn't build it but the
    # state matrix for that seems inconclusive, ENV.compiler doesn't actually
    # mean for sure that we used that compiler.
  end

  test do
    (testpath/'hello.go').write <<-EOS.undent
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello World")
    }
    EOS
    # Run go vet check for no errors then run the program.
    # This is a a bare minimum of go working as it uses vet, build, and run.
    system "#{bin}/go", "vet", "hello.go"
    assert_equal "Hello World\n", `#{bin}/go run hello.go`
  end
end

__END__
# HG changeset patch
# User Dave Cheney <dave@cheney.net>
# Date 1373336072 18000
#      Mon Jul 08 21:14:32 2013 -0500
# Node ID 000ecca1178d67c9b482d3fb0b6a1bc4aeef2472
# Parent  02b673333fab068d9e12106c01748c2d23682bac
cmd/ld: trivial: fix unhandled switch case

Fix warning found by clang 3.3.

R=rsc, r
CC=golang-dev
https://codereview.appspot.com/11022043

diff -r 02b673333fab -r 000ecca1178d src/cmd/ld/lib.c
--- a/src/cmd/ld/lib.c	Tue Jul 09 11:12:05 2013 +1000
+++ b/src/cmd/ld/lib.c	Mon Jul 08 21:14:32 2013 -0500
@@ -665,6 +665,9 @@
 	case '6':
 		argv[argc++] = "-m64";
 		break;
+	case '5':
+		// nothing required for arm
+		break;
 	}
 	if(!debug['s'] && !debug_s) {
 		argv[argc++] = "-gdwarf-2"; 


require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  url 'http://go.googlecode.com/files/go1.0.3.src.tar.gz'
  version '1.0.3'
  sha1 '1a67293c10d6c06c633c078a7ca67e98c8b58471'
  head 'https://go.googlecode.com/hg/'

  skip_clean 'bin'

  option '[linux|freebsd|netbsd|openbsd|windows]-[arm|amd64|386]', "Build cross-compilers and runtime support. Ex. --linux-arm"

  devel do
    url 'https://go.googlecode.com/files/go1.1beta2.src.tar.gz'
    version '1.1beta2'
    sha1 '70d7642a6ea065a23458b9ea28e370b19912e52d'
  end

  unless build.stable?
    fails_with :clang do
      cause "clang: error: no such file or directory: 'libgcc.a'"
    end
  end

  def install
    # install the completion scripts
    (prefix/'etc/bash_completion.d').install 'misc/bash/go' => 'go-completion.bash'
    (share/'zsh/site-functions').install 'misc/zsh/go' => '_go'

   targets = []
   targets << ['linux', ['arm'], { :cgo => false }] if build.include? 'linux-arm'
   targets << ['linux', ['386'], { :cgo => false }] if build.include? 'linux-386'
   targets << ['linux', ['amd64'], { :cgo => false }] if build.include? 'linux-amd64'
   targets << ['freebsd', ['arm'], { :cgo => false }] if build.include? 'freebsd-arm'
   targets << ['freebsd', ['386'], { :cgo => false }] if build.include? 'freebsd-386'
   targets << ['freebsd', ['amd64'], { :cgo => false }] if build.include? 'freebsd-amd64'
   targets << ['netbsd', ['arm'], { :cgo => false }] if build.include? 'netbsd-arm'
   targets << ['netbsd', ['386'], { :cgo => false }] if build.include? 'netbsd-386'
   targets << ['netbsd', ['amd64'], { :cgo => false }] if build.include? 'netbsd-amd64'
   targets << ['openbsd', ['386'], { :cgo => false }] if build.include? 'openbsd-386'
   targets << ['openbsd', ['amd64'], { :cgo => false }] if build.include? 'openbsd-amd64'
   targets << ['windows', ['386'], { :cgo => false }] if build.include? 'windows-386'
   targets << ['windows', ['amd64'], { :cgo => false }] if build.include? 'windows-amd64'
   targets << ['darwin', ['386'], { :cgo => false }] if build.include? 'darwin-386'
   targets << ['darwin', ['amd64'], { :cgo => false }] if build.include? 'darwin-amd64'

   # We always build some form of darwin so that there is something
   # that can create native go executables.
   unless (build.include? 'darwin-386') || (build.include? 'darwin-amd64')
      targets << ['darwin', [''], { :cgo => true }]
   end

    # The version check is due to:
    # http://codereview.appspot.com/5654068
    Pathname.new('VERSION').write 'default' if build.head?

    cd 'src' do
      # Build only. Run `brew test go` to run distrib's tests.
      targets.each do |(os, archs, opts)|
      archs.each do |arch|
        ENV['GOROOT_FINAL'] = prefix
        ENV['GOOS']         = os
        ENV['GOARCH']       = arch
        ENV['CGO_ENABLED']  = opts[:cgo] ? "1" : "0"
        allow_fail = opts[:allow_fail] ? "|| true" : ""
        system "./make.bash --no-clean #{allow_fail}"
      end
      end
    end

    # cleanup ENV
    ENV.delete('GOROOT_FINAL')
    ENV.delete('GOOS')
    ENV.delete('GOARCH')
    ENV.delete('CGO_ENABLED')

    Pathname.new('pkg/obj').rmtree

    # Don't install header files; they aren't necessary and can
    # cause problems with other builds. See:
    # http://trac.macports.org/ticket/30203
    # http://code.google.com/p/go/issues/detail?id=2407
    prefix.install(Dir['*'] - ['include'])
  end

  test do
    cd "#{prefix}/src" do
      system "./run.bash", "--no-rebuild"
    end
  end
end

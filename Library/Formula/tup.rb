require 'formula'

class Tup < Formula
  homepage 'http://gittup.org/tup/'
  head 'https://github.com/gittup/tup.git'
  url 'https://github.com/gittup/tup.git', :tag => 'v0.5'
  version '0.5'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    if `kextfind -b org.fuse4x.kext.fuse4x`.chomp.empty?
      onoe <<-EOS.undent
        Tup requires the fuse4x kernel extension to be loadable in order to
        build. Please follow the directions givein by `brew info fuse4x-kext`
        and try again!
      EOS
      exit 1
    end

    # Tup hard-wires CC to clang on OS X.
    inreplace ['bootstrap.sh', 'macosx.tup'], /^([ \t]*CC[ \t]*=[ \t]*).*$/, "\\1#{ENV.cc}"
    inreplace 'Tupfile', '`git describe`', version

    system "./bootstrap.sh"
    bin.install 'tup'
    man1.install 'tup.1'
  end

  def test
    system "tup -v"
  end
end

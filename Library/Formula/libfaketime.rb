require 'formula'

class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage 'http://www.code-wizards.com/projects/libfaketime'
  url 'http://code-wizards.com/projects/libfaketime/libfaketime-0.9.5.tar.gz'
  sha1 '12199af854004f231892ab6976c2e99b937e2d61'

  bottle do
    revision 1
    sha1 "f50875aa4b38f408258c144ea55c098fe04b25f2" => :yosemite
    sha1 "42bd3fbc36e8dff01d9b21523f9c3d7385ff0455" => :mavericks
    sha1 "9bf2033a9b41825e0f4b09f7cc619b233ea98d17" => :mountain_lion
  end

  depends_on :macos => :lion

  fails_with :llvm do
    build 2336
    cause 'No thread local storage support'
  end

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install 'src/faketime'
    (lib/'faketime').install 'src/libfaketime.1.dylib'
    man1.install 'man/faketime.1'
  end
end

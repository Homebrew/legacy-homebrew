require 'formula'

class Libfaketime < Formula
  homepage 'http://www.code-wizards.com/projects/libfaketime'
  url 'http://code-wizards.com/projects/libfaketime/libfaketime-0.9.5.tar.gz'
  sha1 '12199af854004f231892ab6976c2e99b937e2d61'

  bottle do
    sha1 "45d7fa0b3ff412ae3a419b8418242eeaad40e6b1" => :mavericks
    sha1 "e88429485903a5a6ad1d667ad0d5ce902fc1a3b8" => :mountain_lion
    sha1 "427a88a2c0884683e0639735067e3999078a6149" => :lion
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

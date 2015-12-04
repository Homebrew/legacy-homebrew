class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "http://www.code-wizards.com/projects/libfaketime"
  url "http://code-wizards.com/projects/libfaketime/libfaketime-0.9.5.tar.gz"
  sha256 "5e07678d440d632bef012068ca58825402da5ad25954513e785717cc539c213d"

  bottle do
    revision 1
    sha256 "5148ca77b62f044e604d80cd18f2a7c46c2bd44ffff2b828eea05b98154f2b17" => :yosemite
    sha256 "9beebb4e5b6fa274f6114a141d7c20f726532e851496733b60825e9c75926480" => :mavericks
    sha256 "4b7477042b15dd475fc16de06df07e9cc3a983033d6d21ac6029dfc1ddfb1925" => :mountain_lion
  end

  depends_on :macos => :lion

  fails_with :llvm do
    build 2336
    cause "No thread local storage support"
  end

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end
end

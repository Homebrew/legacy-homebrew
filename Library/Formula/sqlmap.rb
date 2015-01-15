class Sqlmap < Formula
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz"
  sha1 "25d7c13fc6e8bb55a1b4d9ba60a7ebd558ad0374"
  head "https://github.com/sqlmapproject/sqlmap.git"
  revision 1

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"sqlmap.py"
    bin.install_symlink libexec/"sqlmapapi.py" if build.head?

    bin.install_symlink bin/"sqlmap.py" => "sqlmap"
  end

  test do
    system bin/"sqlmap", "--version"
  end
end

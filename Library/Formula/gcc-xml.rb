class GccXml < Formula
  desc "XML output extension to GCC"
  homepage "https://gccxml.github.io/"
  url "http://www.gccxml.org/files/v0.6/gccxml-0.6.0.tar.gz"
  sha256 "5efcad16ffa33eea6aea4c918f45838e3c826ad0e3d32d85f96f2b49bd66ba94"
  head do
    url "https://github.com/gccxml/gccxml.git"
  end

  depends_on "cmake" => :build

  def install
    mkdir "gccxml-build" do
      system "cmake", "..", "-DMAKE_INSTALL_PREFIX:PATH=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gccxml", "--version"
  end
end

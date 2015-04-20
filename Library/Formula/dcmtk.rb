class Dcmtk < Formula
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20150217.tar.gz"
  sha256 "3cf8f3e52ed8a5240a7facc3a118de411aa54bc9beccba0cf7a975735da35304"
  version "3.6.1-20150217"

  bottle do
    sha1 "7a5dae3786225a07fc1b615c186a348d762c1a67" => :mavericks
    sha1 "f2b20d273322b799b4bd79da8dbe21bc293f37ff" => :mountain_lion
    sha1 "044eeba49ae368d5f8cce753d54dcaa9b8d18fbb" => :lion
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-openssl", "Configure DCMTK with support for OpenSSL"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_WITH_OPENSSL=YES" if build.with? "openssl"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make", "DOXYGEN" if build.with? "docs"
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    File.exist? testpath/"out.dcm"
  end
end

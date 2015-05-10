class Dcmtk < Formula
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20150217.tar.gz"
  sha256 "3cf8f3e52ed8a5240a7facc3a118de411aa54bc9beccba0cf7a975735da35304"
  version "3.6.1-20150217"

  bottle do
    sha256 "0bd582c2f37ce4b9366b0a7ba2e7c6e90cddd3a6af954ebc5475938048415d5d" => :yosemite
    sha256 "ff49c45d86930592662caf947cd87f011b55f533396b75957e55cd748bc4c7b2" => :mavericks
    sha256 "2e06bdf73ce156ba65c95374ac5a9e6b048c02186403b66b78ea48b2b415da01" => :mountain_lion
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

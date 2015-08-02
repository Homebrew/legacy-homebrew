class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now.
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20150217.tar.gz"
  sha256 "3cf8f3e52ed8a5240a7facc3a118de411aa54bc9beccba0cf7a975735da35304"
  version "3.6.1-20150217"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    revision 1
    sha256 "01a5f4a8eae4a776974753de4c5af76c3465f1cbdb3e8413130bbd8558815465" => :yosemite
    sha256 "5ae479f470798ef7724dfa485906e6be9de6ee3b21deb99345e493256974a849" => :mavericks
    sha256 "43035c832346690513f2180216f74caa6ffabe3714e35131639a5f342c0e6b51" => :mountain_lion
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-openssl", "Configure DCMTK with support for OpenSSL"
  option "with-libiconv", "Build with brewed libiconv. Dcmtk and system libiconv can have problems with utf8."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_WITH_OPENSSL=YES" if build.with? "openssl"
    args << "-DDCMTK_WITH_ICONV=YES -DLIBICONV_DIR=#{Formula["libiconv"].opt_prefix}" if build.with? "libiconv"
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
    system bin/"dcmftest", testpath/"out.dcm"
  end
end

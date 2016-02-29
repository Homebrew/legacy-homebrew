class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now.
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20160216.tar.gz"
  version "3.6.1-20160216"
  sha256 "51c1075a5c0b631ac0849a967862eaa55466df0aa8c4704f9d67b541bedba812"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "177f217df6e3eccb68e5306222b136ed87609f89f041f4451459e4a78f5eaf33" => :el_capitan
    sha256 "15ce712721b1a1d52095dda6ccaee211920357834f26e39241673e6513a1fa9a" => :yosemite
    sha256 "8d788453c0221597d65effe0b814aedb371d1b28170bc38be904823d28d5c0d7" => :mavericks
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
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
    args << "-DDCMTK_WITH_OPENSSL=YES"
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
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

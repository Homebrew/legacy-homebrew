class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "http://dicom.offis.de/dcmtk.php.en"

  # Current snapshot used for stable now.
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20150924.tar.gz"
  version "3.6.1-20150924"
  sha256 "37a3cff61adaec87ff0eae553827b63cb9420c14c88d1d5b719cae7c70510e52"

  head "git://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "0d56126bc1dd55f045816fe7c53016f07848c86c81dfd22b8be527bf703d26a7" => :el_capitan
    sha256 "b2eb59af611eaaeadca4ff91c7ece1045f8275ff456608fabbcf278eec0305a2" => :yosemite
    sha256 "0ba966c6431a517db331e6b2857d596e609f7fe46d28ff4a5e17c9e835549e99" => :mavericks
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

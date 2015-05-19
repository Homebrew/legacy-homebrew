class Dcmtk < Formula
  homepage "http://dicom.offis.de/dcmtk.php.en"
  revision 2

  stable do
    url "ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk360/dcmtk-3.6.0.tar.gz"
    sha1 "469e017cffc56f36e834aa19c8612111f964f757"

    # This roughly corresponds to thefollowing upstream patch:
    #
    #   http://git.dcmtk.org/web?p=dcmtk.git;a=commitdiff;h=dbadc0d8f3760f65504406c8b2cb8633f868a258
    #
    # However, this patch can"t be applied as-is, since it refers to
    # some files that don"t exist in the 3.6.0 release.
    #
    # This patch can be dropped once DCMTK makes a new release, but
    # since this is a very rare occurrence (the last development preview
    # release is from mid 2012), it seems justifiable to keep the patch
    # ourselves for a while.
    patch :DATA
  end

  devel do
    version "3.6.1_20150217"
    url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20150217.tar.gz"
    sha256 "3cf8f3e52ed8a5240a7facc3a118de411aa54bc9beccba0cf7a975735da35304"
  end

  bottle do
    sha256 "0bd582c2f37ce4b9366b0a7ba2e7c6e90cddd3a6af954ebc5475938048415d5d" => :yosemite
    sha256 "ff49c45d86930592662caf947cd87f011b55f533396b75957e55cd748bc4c7b2" => :mavericks
    sha256 "2e06bdf73ce156ba65c95374ac5a9e6b048c02186403b66b78ea48b2b415da01" => :mountain_lion
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-openssl", "Configure DCMTK with support for OpenSSL"
  option "with-libiconv", "Build with libiconv"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl" => :optional
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_WITH_OPENSSL=YES -DWITH_OPENSSLINC=#{Formula["openssl"].opt_prefix}" if build.with? "openssl"
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
    File.exist? testpath/"out.dcm"
  end
end

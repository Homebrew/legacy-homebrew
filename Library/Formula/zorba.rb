class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.0.tar.gz"
  sha256 "75661fed35fb143498ba6539314a21e0e2b0cc18c4eaa5782d488430ac4dd9c8"
  revision 2

  bottle do
    sha256 "db15418a3274cf4aeb35937e230ce97698182ddfde37807f16c035c8a5135ca0" => :el_capitan
    sha256 "32c0d43f093d70c672cd5aff4c0f5e5e4fe401c88db84e7cea78793a3871a7ba" => :yosemite
    sha256 "434987a856a507071999d743d5cef45693a4c2a0f905f0d52489ada70183e558" => :mavericks
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "swig" => [:build, :recommended]
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DZORBA_VERIFY_PEER_SSL_CERTIFICATE=ON" if build.with? "ssl-verification"
    args << "-DZORBA_WITH_BIG_INTEGER=ON" if build.with? "big-integer"

    # https://github.com/Homebrew/homebrew/issues/42372
    # Seems to be an assumption `/usr/include/php` will exist without an obvious
    # override to that logic.
    args << "-DZORBA_SUPPRESS_SWIG=ON" if !MacOS::CLT.installed? || build.without?("swig")

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end

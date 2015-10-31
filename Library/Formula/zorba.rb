class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.0.tar.gz"
  sha256 "75661fed35fb143498ba6539314a21e0e2b0cc18c4eaa5782d488430ac4dd9c8"
  revision 1

  bottle do
    revision 1
    sha256 "c0ee1204ff3304c4f94d312ba58a24ae343f2d5da5bfb35bead0415e88bfc525" => :el_capitan
    sha256 "35a06380c4e9a24c3e1418582115d09ff64c55992af7db7f66a23350e2d5408b" => :yosemite
    sha256 "84ff60b021ec3944f24c351bde93b40f8f8c377f7d0258ba4c8fd0f8c7f23e9a" => :mavericks
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "swig" => [:build, :recommended]
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

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

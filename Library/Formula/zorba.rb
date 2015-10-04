class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.0.tar.gz"
  sha256 "75661fed35fb143498ba6539314a21e0e2b0cc18c4eaa5782d488430ac4dd9c8"
  revision 1

  bottle do
    sha256 "de910581ab17813af055afa2aa25617141c35a01844075703b0f56c3a2266a31" => :yosemite
    sha256 "817415ea7f4d9e3011aa7c2492a2e8c5c7e064c938d5fb7a7b0e322d93eb99b1" => :mavericks
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  needs :cxx11

  def install
    ENV.cxx11

    cmake_args = std_cmake_args
    cmake_args << "-DZORBA_VERIFY_PEER_SSL_CERTIFICATE=ON" if build.with? "ssl-verification"
    cmake_args << "-DZORBA_WITH_BIG_INTEGER=ON" if build.with? "big-integer"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end

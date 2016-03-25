class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  url "https://projects.universe-factory.net/attachments/download/81/fastd-17.tar.xz"
  sha256 "26d4a8bf2f8cc52872f836f6dba55f3b759f8c723699b4e4decaa9340d3e5a2d"
  head "https://git.universe-factory.net/fastd/", :using => :git

  bottle do
    cellar :any
    revision 1
    sha256 "c1b8aabdbc97b96d5e90c782d97529cfd67ecbc6e11c168c220b74b535023ba1" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libuecc"
  depends_on "libsodium"
  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl" => :optional
  depends_on :tuntap => :recommended

  def install
    args = std_cmake_args
    args << "-DENABLE_LTO=ON"
    args << "-DENABLE_OPENSSL=ON" if build.with? "openssl"
    args << buildpath
    mkdir "fastd-build" do
      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd"
  end
end

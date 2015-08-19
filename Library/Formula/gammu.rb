class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "http://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.36.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.36.0.orig.tar.xz"
  sha256 "9c89fd204e190db5b301d28b793e8d0f2b05069a5b2b91fde451a6dae7f7d633"

  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "c5e3744176b3609902070f07ced499d02570a8dc0d5aa72e02383b8e9bcce5a4" => :yosemite
    sha256 "106312958bcfb95929178a716ca5cd458ee37ba9e6ad6ca80ba3dbb0ac8c8b40" => :mavericks
    sha256 "d1f54aae239138586fbc5693120a28b58eb709811461478b8dc976345b3de3df" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "gettext" => :optional
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DINSTALL_BASH_COMPLETION=OFF"
    args << "-DWITH_PYTHON=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end

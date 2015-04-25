class Gammu < Formula
  homepage "http://wammu.eu/gammu/"
  url "http://dl.cihar.com/gammu/releases/gammu-1.36.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.36.0.orig.tar.xz"
  sha256 "9c89fd204e190db5b301d28b793e8d0f2b05069a5b2b91fde451a6dae7f7d633"

  head "https://github.com/gammu/gammu.git"

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

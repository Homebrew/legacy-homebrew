class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://launchpad.net/mydumper/0.6/0.6.2/+download/mydumper-0.6.2.tar.gz"
  version "0.6.2"
  sha256 "fa28563e8967752828954c5d81e26ef50aad9083d50a977bf5733833b23e3330"

  depends_on "cmake" => :build
  depends_on "sphinx" => :python
  depends_on "glib"
  depends_on "mysql"
  depends_on "pcre"
  depends_on "pkgconfig"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def test
    system "mydumper" "--help"
  end
end

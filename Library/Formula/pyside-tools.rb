class PysideTools < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"

  head "https://github.com/PySide/Tools.git"

  bottle do
    sha256 "1f61192245b05946057f47d6a73788a998c86eefc846e1d09821a316c5bc2975" => :yosemite
    sha256 "2cb88ceddebde2c5ff388a090b53f9a8c6dc986d881a1eab1f57ff2cdb43edf0" => :mavericks
    sha256 "0c829a3c663e1cdecc343377d7e0ddfe18fc8518360ed495695fefe84da7b221" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pyside"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end

class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.1.tar.gz"
  sha256 "4c30ef43814549974a5b01fb1a94eb72ff08628c5a421085b1ce3bfe0524df42"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a4a5fbe64015f701ebb4dde35905f333c66ed2365b5880d54f1ffccd1261616" => :el_capitan
    sha256 "95ed6efb5d64d447d4c5b86e65746282b4e146610ce008e37a73c75ffcfd2db5" => :yosemite
    sha256 "8b885955dcf5abcc9bdf424a1db9f03f94e287ffddaef9fd281d55c4ed8928fd" => :mavericks
  end

  # OSX compatibility
  patch do
    url "https://github.com/raboof/nethogs/commit/9eae9e13434bc2e27fc28731a67de2ae83737783.patch"
    sha256 "a9e00bc05ab4c4b12df294975e6ce929ae57e005e14a9c4956bb2d0497e7e6a0"
  end

  # Add CPPFLAGS in Makefile
  patch do
    url "https://github.com/raboof/nethogs/commit/544a06b024eb4b24c807e77ae871c2c270cb74af.patch"
    sha256 "8f0edf78be727c79fd933380a889156a01f25994acf05afb2aa6d6d1df8acac3"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{sbin}/nethogs", "-V" # Using -V because other nethogs commands need to be run as root
  end
end

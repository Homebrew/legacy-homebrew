class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.18.tar.gz"
  sha256 "239746de41c845af52bb3c14055558f743292dd6c24ac26c2d6567a5a6093926"

  bottle do
    cellar :any
    sha256 "6f5a5f6120c9c9a61df4d706b6ec3fb8825ea07e013367e5b92158e361decb60" => :el_capitan
    sha256 "fe1507d296341a28e7f4ec68dabbbcdcd7f2f07371b74a594ee99dd8f2bd3b36" => :yosemite
    sha256 "29fb6a44d6ea50f8bc7cedf6dbdf6de9ad85c9568797ff40b4cb25c2ac28b07a" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

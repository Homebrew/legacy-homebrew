class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.18.tar.gz"
  sha256 "239746de41c845af52bb3c14055558f743292dd6c24ac26c2d6567a5a6093926"

  bottle do
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

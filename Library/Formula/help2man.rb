require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.2.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.2.tar.xz"
  sha256 "92191decc8c324c88bfec5e989d13108f22ed135d794bde2b3b802ffe3650311"

  bottle do
    cellar :any
    sha1 "13acec14f0cdf3de9c31faae953241f53da2ac0e" => :mavericks
    sha1 "e859195d7c051c7b7f87b59f77c046029d07773c" => :mountain_lion
    sha1 "67b0b7d57eba0b132aad6c79d1a4597d09667364" => :lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

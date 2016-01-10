class Chgems < Formula
  desc "chroot for Ruby gems"
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha256 "515d1bfebb5d5183a41a502884e329fd4c8ddccb14ba8a6548a1f8912013f3dd"
  head "https://github.com/postmodern/chgems.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end

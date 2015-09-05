class Nyancat < Formula
  desc "Nyancat in your terminal, rendered through ANSI escape sequences."
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.4.4.tar.gz"
  sha256 "bbd0e573f01b7b5ee3b9c379de3ce12bb2575654e49b790f09388b2b9bd1f462"

  bottle do
    cellar :any
    sha256 "31fe5465d62a4f922bd29ffdc6ef555517435ba3f76f1e671d8d6adbcfc2acf2" => :yosemite
    sha256 "70811e60480b682b3f6ad8f02dc52bd0bde2df97437df1aa3744f098619f4d2b" => :mavericks
    sha256 "37afa1b385b8a8b07dc762f212e40a42105c23cd9c0ea079cc7c1ec4103a46de" => :mountain_lion
  end

  # Add _DARWIN_C_SOURCE to allow compiling on OSX
  patch do
    url "https://github.com/klange/nyancat/pull/30.patch"
    sha256 "083b22dc19e246c5ba74959e548a07ced10e1776c57530600ffc8606153b4d1c"
  end

  # Makefile: Add install directory option
  patch do
    url "https://github.com/klange/nyancat/pull/34.patch"
    sha256 "407e01bae1d97e5153fb467a8cf0b4bc68320bea687294d56bcbacc944220d2c"
  end

  def install
    system "make"
    system "make", "install", "instdir=#{prefix}"
  end

  test do
    system "#{bin}/nyancat", "--frames", "1"
  end
end

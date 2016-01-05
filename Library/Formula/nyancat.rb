class Nyancat < Formula
  desc "Nyancat in your terminal, rendered through ANSI escape sequences."
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.5.1.tar.gz"
  sha256 "c948c769d230b4e41385173540ae8ab1f36176de689b6e2d6ed3500e9179b50a"

  bottle do
    cellar :any
    sha256 "31fe5465d62a4f922bd29ffdc6ef555517435ba3f76f1e671d8d6adbcfc2acf2" => :yosemite
    sha256 "70811e60480b682b3f6ad8f02dc52bd0bde2df97437df1aa3744f098619f4d2b" => :mavericks
    sha256 "37afa1b385b8a8b07dc762f212e40a42105c23cd9c0ea079cc7c1ec4103a46de" => :mountain_lion
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

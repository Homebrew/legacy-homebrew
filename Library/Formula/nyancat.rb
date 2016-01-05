class Nyancat < Formula
  desc "Nyancat in your terminal, rendered through ANSI escape sequences."
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.5.1.tar.gz"
  sha256 "c948c769d230b4e41385173540ae8ab1f36176de689b6e2d6ed3500e9179b50a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7edb311fcaaf95c46bcd4c50846ea00423bb91ca11f50c07555a371ff0e05318" => :el_capitan
    sha256 "d9c2f795fb32f1201ddd421911d6d36e7f5318f410fb543fb4bda39d731454c8" => :yosemite
    sha256 "4e6af8e2d8c954b4008a53bc25707ce0c7ff0c913b4ecfe8e7ee9526b6aa581b" => :mavericks
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

class Libuuid < Formula
  homepage "https://sourceforge.net/projects/libuuid/"
  # tag "linuxbrew"

  url "https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
  sha256 "46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644"

  conflicts_with "ossp-uuid", :because => "both install lib/libuuid.a"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end

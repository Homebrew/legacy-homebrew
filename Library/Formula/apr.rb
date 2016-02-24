class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.5.2.tar.bz2"
  sha256 "7d03ed29c22a7152be45b8e50431063736df9e1daa1ddf93f6a547ba7a28f67a"

  bottle do
    sha256 "ce60ca59b86b7e0bba92bd04b91a0667a4c9e2061358d728da7aa8b7053b0541" => :el_capitan
    sha256 "5ae775d6f6a3fb46b1b262e1c0ecb2aca4e5a29ea1f841672ac430b4d49606af" => :yosemite
    sha256 "691b67fdf7077bca9db5cb0fcc40856dd82914bb00868c4e1a6a692abca87913" => :mavericks
    sha256 "4d5e7c20d507c48712d8ba549f500e7e58a4782dd1e88aee6d2eb1a169aeeaf9" => :mountain_lion
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/apr-1-config", "--link-libtool", "--libs"
  end
end

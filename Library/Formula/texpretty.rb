class Texpretty < Formula
  desc "prettyprint TeX files"
  homepage "http://ftp.math.utah.edu/pub/texpretty/"
  url "http://ftp.math.utah.edu/pub/texpretty/texpretty-0.02.tar.bz2"
  sha256 "d8e07c29cad7eb7eb8159fd3d03ac0a746ea5f380062af9f1e52061691152526"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    man1.mkpath
    bin.mkpath
    system "make", "install"
  end

  test do
    system "texpretty", "-a"
  end
end

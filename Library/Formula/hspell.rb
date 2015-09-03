class Hspell < Formula
  desc "The Hspell project is a free Hebrew linguistic project."
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.3.tar.gz"
  sha256 "603c25dcbaa65d171d9065da7369cfe0dc21bda8378bade13b42eda69c8b2fe7"

  def install
    inreplace "Makefile.in", "soname", "install_name"

    system "./configure", "--prefix=#{prefix}", 
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    system "hspell", "-v"
  end
end

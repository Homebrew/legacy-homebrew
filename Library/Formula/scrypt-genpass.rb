require "formula"

class ScryptGenpass < Formula
  homepage "https://github.com/chrisoei/scrypt-genpass"
  head "https://github.com/chrisoei/scrypt-genpass.git"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"scrypt-genpass", "-t"
  end
end

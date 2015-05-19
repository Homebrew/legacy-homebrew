class Miruo < Formula
  homepage "https://github.com/KLab/miruo/"
  url "https://github.com/KLab/miruo/archive/0.9.6.tar.gz"
  sha256 "bbb2989cad13b7a7541413352044dff9733121fcc82c29ced3bdfbf6b829d9b4"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    system "#{bin}/miruo", "--version"
  end
end

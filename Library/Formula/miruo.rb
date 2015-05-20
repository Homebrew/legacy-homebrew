class Miruo < Formula
  homepage "https://github.com/KLab/miruo/"
  url "https://github.com/KLab/miruo/archive/0.9.6a.tar.gz"
  sha256 "346e8bd892fe15e6859486d50231238879d3b620b93df444b13a910e84864e7f"
  version "0.9.6a"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    system "#{sbin}/miruo", "--version"
  end
end

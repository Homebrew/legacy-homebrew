class Darkstat < Formula
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.718.tar.bz2"
  sha256 "682f3e53f4e89ea6ad08236b4225a5e0859428299765d8d995374cd7fa22adff"

  devel do
    url "https://unix4lyfe.org/darkstat/darkstat-3.0.719rc1.tar.bz2"
    sha256 "827e91aa9261d3f6783cf3f8affa80590800cc5740dcac5f42c88e2bc781390b"
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end

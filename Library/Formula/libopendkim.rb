class Libopendkim < Formula
  desc "Implementation of Domain Keys Identified Mail authentication"
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.10.3.tar.gz"
  sha256 "43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b"

  bottle do
    sha256 "42f6bac489a74cf6f05f059c454b8b821c884abc71138f811fb72e4feca14f6d" => :yosemite
    sha256 "4177829cd1e50e4723c815b747298277554a0a52176601c1f56b5c548ba133ff" => :mavericks
    sha256 "e9196bde7304789169ceb844a7bea8b67e273e6005ed93ffd80d0a4d5af6241c" => :mountain_lion
  end

  depends_on "unbound"
  depends_on "openssl"

  def install
    # --disable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula["unbound"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/opendkim-genkey", "--directory=#{testpath}"
    assert File.exist?("default.private")
    assert File.exist?("default.txt")
  end
end

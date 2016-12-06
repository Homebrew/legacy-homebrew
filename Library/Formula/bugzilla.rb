class Bugzilla < Formula
  desc "Bugzilla is server software designed to help you manage software development."
  homepage "https://www.bugzilla.org"
  url "https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-5.0.1.tar.gz"
  version "5.0.1"
  sha256 "f0f85bf405984770d65f60f5a828ea4d173acaca4aa85e4e58b4e88b1ae186a5"

  depends_on :x11 

  def install

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end

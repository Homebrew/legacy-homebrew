class Whatever < Formula
  desc "Dummy formula for testing brew --pull"
  homepage "http://www.example.com/nonexistent-apps/whatever"
  url "http://www.example.com/nonexistent-apps/whatever/downloads/whatever-1.2.3.tgz"
  sha256 "eaf18aee18fe69d37eb8594aa3d7018a1dd7fda2fad1618f0b68a6cbb39544d1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "whatever"
  end
end

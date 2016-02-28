class Lcab < Formula
  desc "Cabinet file creation tool"
  homepage "http://ohnopub.net/~ohnobinki/lcab/"
  url "http://mirror.ohnopub.net/mirror/lcab-1.0b12.tar.gz"
  mirror "https://launchpad.net/ubuntu/intrepid/+source/lcab/1.0b12-3/+files/lcab_1.0b12.orig.tar.gz"
  sha256 "065f2c1793b65f28471c0f71b7cf120a7064f28d1c44b07cabf49ec0e97f1fc8"

  bottle do
    cellar :any
    sha256 "10fc88aa964ecf8b1b9a9dc0baca91b07418ff912abcfc78bf42d53795e8cd76" => :yosemite
    sha256 "8820e54c9322556195ed64afb37648e65c5c613251737c713972e3b7654ffaca" => :mavericks
    sha256 "ba57da441ce55e0c64d3d96a8660859b8a79979f8fb9f8fe20bdf14f09645d4a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "a test"

    system "#{bin}/lcab", "test", "test.cab"
    assert File.exist? "test.cab"
  end
end

class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "http://invisible-island.net/bcpp/"
  url "ftp://invisible-island.net/bcpp/bcpp-20131209.tgz"
  sha1 "5b38e0ae532ed5fc9ee8d5fc8bf84511d55080a8"

  bottle do
    cellar :any
    sha1 "cfb51c877c07ca763570481f7aaa8266090892ee" => :yosemite
    sha1 "8bb51fb15c993112d0fac70baf694f1682a69456" => :mavericks
    sha1 "45b5a1f149bb2cbca9b0c24bb066c82a8e92a6d1" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
              test
                 test
          test
                test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert File.exist?("test.txt.orig")
    assert File.exist?("test.txt")
  end
end

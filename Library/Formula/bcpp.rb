class Bcpp < Formula
  homepage "http://invisible-island.net/bcpp/"
  url "ftp://invisible-island.net/bcpp/bcpp-20131209.tgz"
  sha1 "5b38e0ae532ed5fc9ee8d5fc8bf84511d55080a8"

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

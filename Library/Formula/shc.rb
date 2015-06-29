class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.1.tar.gz"
  sha256 "7fa6c5c4afe2579cbf92fdf2b71c61504d0b1c0caede3dc1f7e5e95e2c37cb0e"

  def install
    bin.mkpath
    inreplace "main/makefile", "$(INSTALL_PATH)/man", man
    system "make", "-C", "main", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/bin/sh
      exit 0
    EOS
    system "#{bin}/shc", "-f", "test.sh", "-o", "test"
    system "./test"
  end
end

class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.2.tar.gz"
  sha256 "b3aabc5d307a80049139bce1b36cb2fd2a9c6c80a6cd951b69dc23e3af91a593"

  head "https://github.com/neurobin/shc.git"

  def install
    # Fix install scripts' permissions.
    # submitted upstream: https://github.com/neurobin/shc/pull/8
    chmod 0755, ["configure", "config/install-sh"]

    system "./configure"
    system "make", "install", "prefix=#{prefix}"
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

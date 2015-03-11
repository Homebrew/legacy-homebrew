class Chkrootkit < Formula
  homepage "http://www.chkrootkit.org/"
  url "https://mirrors.kernel.org/debian/pool/main/c/chkrootkit/chkrootkit_0.50.orig.tar.gz"
  sha256 "9548fc922b0cb8ddf055faff4a4887f140a31c45f2f5e3aa64aad91ecfa56cc7"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end

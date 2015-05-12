class ReginaRexx < Formula
  homepage "http://regina-rexx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.1/Regina-REXX-3.9.1.tar.gz"
  sha256 "5d13df26987e27f25e7779a2efa87a5775213beeda449a9efac59b57a5d5f3ee"

  def install
    ENV.j1 # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end

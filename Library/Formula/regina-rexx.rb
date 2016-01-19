class ReginaRexx < Formula
  desc "Regina REXX interpreter"
  homepage "http://regina-rexx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.1/Regina-REXX-3.9.1.tar.gz"
  sha256 "5d13df26987e27f25e7779a2efa87a5775213beeda449a9efac59b57a5d5f3ee"

  bottle do
    sha256 "4be2121b50a9d988ad30b592c3123ea913a26082a2b1be7ca3ee83ae75b944d3" => :yosemite
    sha256 "6f42da795be18742801fcbf740714cf9131bcb53ce44aac50a2416b3ec7607d2" => :mavericks
    sha256 "d19717c2d929a7e0d4253e62e4d85751e0d57216d369f965b94c9ce89ff34eb5" => :mountain_lion
  end

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

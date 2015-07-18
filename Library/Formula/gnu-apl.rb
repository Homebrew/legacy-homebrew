class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "http://ftpmirror.gnu.org/apl/apl-1.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-1.4.tar.gz"
  sha256 "69da31db180e6ae17116122758c266e19f62e256f04e3c4959f6f2b224a1893a"

  bottle do
    sha1 "e067c7741c9f7e174f0a5f06d99e59fe5b6e930b" => :mavericks
  end

  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on :macos => :mavericks

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.apl").write <<-EOS.undent
      'Hello world'
      )OFF
    EOS

    pid = fork do
      exec "#{bin}/APserver"
    end
    sleep 4

    begin
      assert_match /Hello world/, shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

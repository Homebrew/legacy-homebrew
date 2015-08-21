class GnuApl < Formula
  version "1.5"
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "svn://svn.sv.gnu.org/apl/trunk", :revision => "662"
  head "svn://svn.sv.gnu.org/apl/trunk"

  bottle do
    revision 1
    sha256 "0a061c8ca10b237d15eddd13acf0bc1007b1b18888eda30cd43beeaa77602979" => :yosemite
    sha256 "350db093b3749d355147717f3e3209378c32aae2e508e2b54534f002be5fdedd" => :mavericks
  end

  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on :macos => :mavericks
  depends_on "postgresql" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
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

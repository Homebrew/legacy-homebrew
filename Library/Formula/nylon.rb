class Nylon < Formula
  desc "Proxy server"
  homepage "http://monkey.org/~marius/pages/?page=nylon"
  url "http://monkey.org/~marius/nylon/nylon-1.21.tar.gz"
  sha256 "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4"

  bottle do
    sha256 "aad7532324d564e2581496cc6e097a3f9eb35f40d55349204060c6fbd88d7e96" => :yosemite
    sha256 "5f3cb163129bc0a095c1fb89efaaa2e346aadd16497e14017d809cf1777492fb" => :mavericks
    sha256 "3535d269b712d79968b3ce72ac7266d72aa93ad83df2c61b328d9a563b428497" => :mountain_lion
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    assert_equal "nylon: nylon version #{version}",
      shell_output("#{bin}/nylon -V 2>&1").chomp
  end
end

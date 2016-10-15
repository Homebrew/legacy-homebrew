class Mactelnet < Formula
  homepage "https://github.com/haakonnessjoen/MAC-Telnet"
  url "https://github.com/haakonnessjoen/MAC-Telnet/archive/v0.4.0.tar.gz"
  sha1 "57f2a4ae4930e1b4d57c41dd2fafb38ca1142ec5"

  depends_on "gettext"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  # MAC-Telnet 0.4.0 doesn't build against Mac OS X:
  #   https://github.com/haakonnessjoen/MAC-Telnet/issues/13
  #
  # The patch below was submitted as:
  #   https://github.com/haakonnessjoen/MAC-Telnet/pull/14
  patch :p1 do
    url "https://github.com/haakonnessjoen/MAC-Telnet/commit/8e70ba79fc8b36bfd4ff919308775c2b00005575.diff"
    sha1 "1a0a1bc38e025aeb2165689c614c28653853d8ca"
  end

  test do
    # There isn't really a way to test these tools without a Mikrotik device around.
    # We can, however, check that it tries to connect and fails in the right way.
    assert_equal "Connection failed.\n", shell_output("#{bin}/mactelnet -t 1 -u user -p pass 00:11:22:33:44:55 2>&1", 1)
  end
end

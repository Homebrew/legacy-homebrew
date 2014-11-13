class Src < Formula
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-0.18.tar.gz"
  sha1 "d4234bb6c56073204836ab23d18f36c1a732dd2c"

  # test is failing on Mountain Lion
  depends_on :macos => :mavericks

  def install
    # OSX doesn't provide a /usr/bin/python2. Upstream has been notified but
    # cannot fix the issue. See:
    #   https://github.com/Homebrew/homebrew/pull/34165#discussion_r22342214
    inreplace "src", "#!/usr/bin/env python2", "#!/usr/bin/env python"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "foo"
    system "#{bin}/src", "commit", "-m", "hello", "test.txt"
    system "#{bin}/src", "status", "test.txt"
  end
end

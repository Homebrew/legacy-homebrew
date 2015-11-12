class Jsawk < Formula
  desc "Like awk, but for JSON, using JavaScript objects and arrays"
  homepage "https://github.com/micha/jsawk"
  url "https://github.com/micha/jsawk/archive/1.4.tar.gz"
  sha256 "3d38ffb4b9c6ff7f17072a12c5817ffe68bd0ab58d6182de300fc1e587d34530"
  head "https://github.com/micha/jsawk.git"

  bottle :unneeded

  depends_on "spidermonkey"

  def install
    bin.install "jsawk"
  end

  test do
    cmd = %(#{bin}/jsawk 'this.a = "foo"')
    assert_equal %({"a":"foo"}\n), pipe_output(cmd, "{}")
  end
end

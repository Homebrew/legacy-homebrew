class Jsawk < Formula
  desc "Like awk, but for JSON, using JavaScript objects and arrays"
  homepage "https://github.com/micha/jsawk"
  url "https://github.com/micha/jsawk/archive/1.4.tar.gz"
  sha1 "4f2c962c8a5209764116457682985854400cbf24"

  head "https://github.com/micha/jsawk.git"

  depends_on "spidermonkey"

  def install
    bin.install "jsawk"
  end

  test do
    cmd = %(#{bin}/jsawk 'this.a = "foo"')
    assert_equal %({"a":"foo"}\n), pipe_output(cmd, "{}")
  end
end

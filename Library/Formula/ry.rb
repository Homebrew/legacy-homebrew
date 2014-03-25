require "formula"

class Ry < Formula
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.4.2.tar.gz"
  sha1 "ebce2e822dd62df62af1f6a12701d815bea58ac2"

  head "https://github.com/jayferd/ry.git"

  depends_on "ruby-build" => :recommended

  def install
    ENV["PREFIX"] = HOMEBREW_PREFIX
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Please add to your profile:
      which ry >/dev/null 2>/dev/null && eval "$(ry setup)"
    EOS
  end

  test do
    system "ry", "ls"
  end
end

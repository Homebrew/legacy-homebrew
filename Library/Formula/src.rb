class Src < Formula
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-0.19.tar.gz"
  sha256 "3d9c5c2fe816b3f273aab17520b917a774e90776c766f165efb6ae661378a65c"

  head "git://thyrsus.com/repositories/src.git"

  bottle do
    cellar :any
    revision 1
    sha1 "65716b34afa534be339e0a954cc2206398002401" => :yosemite
    sha1 "0a43a156e56b9dc7b62f8fe9cfc9095aa5d3cf64" => :mavericks
    sha1 "cd51d4f5714a360549d9548a25c27a508aa9ae1b" => :mountain_lion
  end

  depends_on "rcs"
  depends_on "asciidoc" if build.head?

  def install
    # OSX doesn't provide a /usr/bin/python2. Upstream has been notified but
    # cannot fix the issue. See:
    #   https://github.com/Homebrew/homebrew/pull/34165#discussion_r22342214
    inreplace "src", "#!/usr/bin/env python2", "#!/usr/bin/env python"

    if build.head?
      ENV["XML_CATALOG_FILES"] = HOMEBREW_PREFIX/"etc/xml/catalog"
    end

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "foo"
    system "#{bin}/src", "commit", "-m", "hello", "test.txt"
    system "#{bin}/src", "status", "test.txt"
  end
end

class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.4.tar.gz"
  sha256 "9c9fbc1255b35c5250ff28c2c8cbdafa6eedb2b037b21985ad93bd6c45350666"

  bottle do
    cellar :any_skip_relocation
    sha256 "05c18ecaa3de91ae186f19c5c85958d8e8dd8a8e0354f154aaae1c551203d8c8" => :el_capitan
    sha256 "e65242bb07c2f607aeb2bda4546eb51e85b5b7f9c6d4f91c3f26495a8696ddde" => :yosemite
    sha256 "b96e3da3b99e4ad8b3ac283acb6923c234af07f011a0b47cfc0a270af1999135" => :mavericks
  end

  head do
    url "git://thyrsus.com/repositories/src.git"
    depends_on "asciidoc" => :build
  end

  conflicts_with "srclib", :because => "both install a 'src' binary"

  depends_on "rcs"

  def install
    # OSX doesn't provide a /usr/bin/python2. Upstream has been notified but
    # cannot fix the issue. See:
    #   https://github.com/Homebrew/homebrew/pull/34165#discussion_r22342214
    inreplace "src", "#!/usr/bin/env python2", "#!/usr/bin/env python"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "foo"
    system "#{bin}/src", "commit", "-m", "hello", "test.txt"
    system "#{bin}/src", "status", "test.txt"
  end
end

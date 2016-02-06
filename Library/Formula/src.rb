class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.4.tar.gz"
  sha256 "9c9fbc1255b35c5250ff28c2c8cbdafa6eedb2b037b21985ad93bd6c45350666"

  bottle do
    cellar :any
    sha256 "654b13895e6e8e7c1f99a007a17d0c6ab26625e2dd732631016dcaeddd5d942d" => :yosemite
    sha256 "91d3fd19e7d8189930d72f03ab1b092a1291252b47076c72c1c1988f69d822e5" => :mavericks
    sha256 "22e3c9dd3842b0d308c56832a04116f7ce8b0a6055a95c4b42c2d3548f02fe5d" => :mountain_lion
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

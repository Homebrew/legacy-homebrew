class Miller < Formula
  desc "Miller is like sed, awk, cut, join, etc. for name-indexed data."
  homepage "http://johnkerl.org/miller/doc/index.html"
  url "https://github.com/johnkerl/miller/archive/v1.0.0.tar.gz"
  sha256 "8e00d1e55609e2deb27537d385646ee4b3a4227070bdb1375ba7eff2a7e92708"

  def install
    # Upon improving miller's build system this souldn't be necessary.
    # Will handle upstream.
    ENV.deparallelize

    system "make"
    bin.mkpath

    # workaround for hardcoded make file. Project is eventually moving
    # to ./configure so this will no longer be necessary:
    # https://github.com/johnkerl/miller/issues/9
    system "HOME=\"#{prefix}\"; make install"
  end

  test do
    # in lieu of any -v we could test a version from, lets just assert that
    # there is available help output
    assert_match(/abs/, pipe_output("#{bin}/mlr -f", ""))
  end
end

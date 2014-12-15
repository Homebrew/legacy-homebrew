require "formula"

class Mbt < Formula
  homepage "http://ilk.uvt.nl/mbt/"
  url "http://software.ticc.uvt.nl/mbt-latest.tar.gz"
  sha1 "37f8bee0b30e3e13aeaf58ad6d757cc3be1ce8f2"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "timblserver"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test mbt`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

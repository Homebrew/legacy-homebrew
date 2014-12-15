require "formula"

class Frog < Formula
  homepage "http://ilk.uvt.nl/frog/"
  url "http://software.ticc.uvt.nl/frog-latest.tar.gz"
  sha1 "613f4ff250e6edaa1339f98c7eb614a7652134ff"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "timblserver"
  depends_on "mbt"
  depends_on "ucto"

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
    # were more thorough. Run the test with `brew test frog`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

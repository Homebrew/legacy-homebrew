require "formula"

class Frogdata < Formula
  homepage "http://ilk.uvt.nl/timbl/"
  url "http://software.ticc.uvt.nl/frogdata-latest.tar.gz"
  sha1 "60e8cb6057d2481d31cd7a0bb588deb14928a50a"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "frog"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=/usr/local/Cellar/frog/latest/"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test frogdata`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

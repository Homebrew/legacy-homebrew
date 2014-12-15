require "formula"


class Timblserver < Formula
  homepage "http://ilk.uvt.nl/timbl/"
  url "http://software.ticc.uvt.nl/timblserver-1.9.tar.gz"
  sha1 "97c48a87c924cfe8421fa151223da792a12d9363"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "timbl"

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
    # were more thorough. Run the test with `brew test timblserver`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

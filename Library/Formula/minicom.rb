class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://alioth.debian.org/projects/minicom/"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/minicom/minicom_2.7.orig.tar.gz"
  sha256 "9ac3a663b82f4f5df64114b4792b9926b536c85f59de0f2d2b321c7626a904f4"

  bottle do
    sha256 "81f7a4e2671a83ed8ee528b74dc47d6b5bf57995d066048b3130a097ff22203d" => :el_capitan
    sha256 "ab76b20b7ad26d544946d6fa39722e3709fd2b2de5c8da3693c56c1829db8f8a" => :yosemite
    sha256 "18f41c6b651d70c248efba991f044d3f1ed4226ec0bd916773609e865abf0c1a" => :mavericks
  end

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats; <<-EOS.undent
    Terminal Compatibility
    ======================
    If minicom doesn't see the LANG variable, it will try to fallback to
    make the layout more compatible, but uglier. Certain unsupported
    encodings will completely render the UI useless, so if the UI looks
    strange, try setting the following environment variable:

      LANG="en_US.UTF-8"

    Text Input Not Working
    ======================
    Most development boards require Serial port setup -> Hardware Flow
    Control to be set to "No" to input text.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v", 1)
  end
end

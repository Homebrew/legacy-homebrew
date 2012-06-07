require 'formula'

class XQuartz272Installed < Requirement
  def satisfied?; MacOS.xquartz_version >= '2.7.2'; end
  def fatal?; true; end
  def message; <<-EOS.undent

    Gv needs libxaw3d, which exists in XQuartz >= 2.7.2, but XQuartz was not
    found on your system.  Because Apple suggests XQuartz for Mt. Lion, it is
    safe to install, and it works well with Homebrew.  After installing XQuartz:
      http://xquartz.macosforge.org/landing/
    and logging out and back in, you will be able to install gv.

    EOS
  end
end

class Gv < Formula
  homepage 'http://www.gnu.org/s/gv/'
  url 'ftp://alpha.gnu.org/gnu/gv/gv-3.7.3.90.tar.gz'
  sha1 'd7820c770e595c93b5fe1ea50776ae11d0decfac'

  # Note: Switch back to ftp://ftp.gnu.org/gnu/gv/ @ gv-3.7.4.
  # This gv version from alpha was released to support libxaw3d >= 1.6.1

  depends_on 'ghostscript'
  depends_on :x11
  depends_on XQuartz272Installed.new

  skip_clean 'share/gv/safe-gs-workdir'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-SIGCHLD-fallback"
    system "make install"
  end
end

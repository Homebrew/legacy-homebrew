require 'formula'

class GnuApl < Formula
  homepage 'http://www.gnu.org/software/apl/'
  url 'http://ftpmirror.gnu.org/apl/apl-1.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/apl/apl-1.3.tar.gz'
  sha1 'f4cd44a716dc5c5af1cd88811e10efa03d327fd2'

  # GNU Readline is required; libedit won't work.
  depends_on 'readline'
  depends_on :macos => :mavericks

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "dumb"
    system "#{bin}/apl", "--version"
  end
end

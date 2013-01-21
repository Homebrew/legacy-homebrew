require 'formula'

class Aacgain < Formula
  homepage 'http://aacgain.altosdesign.com/'
  # This server will autocorrect a 1.9 url back to this 1.8 tarball.
  # The 1.9 version mentioned on the website is pre-release, so make
  # sure 1.9 is actually out before updating.
  # See: https://github.com/mxcl/homebrew/issues/16838
  url 'http://aacgain.altosdesign.com/alvarez/aacgain-1.8.tar.bz2'
  sha1 '331039c4231e4d85ae878795ce3095dd96dcbfdb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

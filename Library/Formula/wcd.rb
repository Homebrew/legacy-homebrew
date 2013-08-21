require 'formula'

class Wcd < Formula
  homepage 'http://wcd.sourceforge.net/'
  url 'http://cl.ly/2M3m1t0M0M1n/download/wcd-5.2.3.tar.gz'
  sha1 '3fcccfc7812cf7b7aa90f8c792aaae6e16ece296'

  depends_on 'gettext'
  depends_on 'ncurses'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test wcd`.
    system "wcd.exe"
  end
end

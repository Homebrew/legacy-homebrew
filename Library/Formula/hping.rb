require 'formula'

class Hping <Formula
  url 'http://www.hping.org/hping2.0.0-rc3.tar.gz'
  homepage 'http://www.hping.org/'
  md5 '029bf240f2e0545b664b2f8b9118d9e8'
  version '2.0.0-rc3'

  def install
    ENV['MANPATH'] = man
    system "./configure"
    inreplace 'Makefile' do |contents|
      contents.change_make_var! "INSTALL_PATH", prefix
    end
    system "make install"
  end

  def patches
    [
      # Added DARWIN os_type and 64 bit compatibility
      "http://gist.github.com/raw/437115/hping2-darwin.patch",
      # Added INSTALL_PATH into Makefile.in
      "http://gist.github.com/raw/437122/hping2-installpath.patch"
    ]
  end

end

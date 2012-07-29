require 'formula'

class Dynamips < Formula
  homepage 'http://www.gns3.net/dynamips/'
  url 'http://sourceforge.net/projects/gns-3/files/Dynamips/0.2.8-RC3-community/dynamips-0.2.8-RC3-community.tar.gz'
  sha1 'ed7138859e6bc381ae0cf0d2620b32099845847c'
  version '0.2.8-RC3'

  depends_on 'libelf'

  def install
    # Install man pages to the standard Homebrew location
    inreplace 'Makefile' do |s|
      s.gsub! %r|\$\(DESTDIR\)/man|, man
    end

    arch = Hardware.is_64_bit? ? 'amd64' : 'x86'

    ENV.j1
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "DESTDIR=#{prefix}",
                   "install"
  end
end

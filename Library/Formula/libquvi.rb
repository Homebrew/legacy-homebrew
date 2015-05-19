require 'formula'

class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage 'http://quvi.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2'
  sha1 'b7ac371185c35a1a9a2135ef4ee61c86c48f78f4'
  revision 1

  bottle do
    revision 1
    sha1 "2b219665889be92e7aae5bc93ccedd956a4a5bf6" => :yosemite
    sha1 "6b9ec93ae6c4b064943befc40596b724a9773618" => :mavericks
    sha1 "6a963aa4d1ce0eb5768a529f07227621b320bab0" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'lua'

  resource 'scripts' do
    url 'https://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.14.tar.xz'
    sha1 'fe721c8d882c5c4a826f1339c79179c56bb0fe41'
  end

  def install
    scripts = prefix/'libquvi-scripts'
    resource('scripts').stage do
      system "./configure", "--prefix=#{scripts}", "--with-nsfw"
      system "make install"
    end
    ENV.append_path 'PKG_CONFIG_PATH', "#{scripts}/lib/pkgconfig"

    # Lua 5.2 does not have a proper lua.pc
    ENV['liblua_CFLAGS'] = ' '
    ENV['liblua_LIBS'] = '-llua'

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

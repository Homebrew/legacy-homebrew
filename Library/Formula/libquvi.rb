require 'formula'

class Libquvi < Formula
  homepage 'http://quvi.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2'
  sha1 'b7ac371185c35a1a9a2135ef4ee61c86c48f78f4'

  bottle do
    sha1 "0c7f04198c8ab41523ecf276654f1dc7d27ef4ed" => :mavericks
    sha1 "46f9329a70b9b512c6cc17b25fbb4f09bbdcbe49" => :mountain_lion
    sha1 "2ecd87014bbb3153a2b8420181f67af491614172" => :lion
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

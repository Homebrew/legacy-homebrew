require 'formula'

class Wxmac <Formula
  url 'http://downloads.sourceforge.net/project/wxwindows/wxMac/2.8.10/wxMac-2.8.10.tar.bz2'
  homepage 'http://www.wxwidgets.org'
  md5 '67e5eb6823907081fc979d41e00f93d7'

  def install
    # Force i386
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

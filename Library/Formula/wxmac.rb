require 'formula'

class Wxmac <Formula
  url 'http://prdownloads.sourceforge.net/wxwindows/wxMac-2.8.10.tar.gz'
  homepage 'http://www.wxwidgets.org'
  md5 'd18668cbf7026b8633e2cfc69e2f3868'

  def install
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

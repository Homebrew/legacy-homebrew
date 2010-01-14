require 'formula'

class AircrackNg <Formula
  url 'http://download.aircrack-ng.org/aircrack-ng-1.0.tar.gz'
  md5 'dafbfaf944ca9d523fde4bae86f0c067'
  homepage 'http://aircrack-ng.org/'
  
  def install
    # Force i386, otherwise you get errors:
    #  sha1-sse2.S:190:32-bit absolute addressing is not supported for x86-64
    #  sha1-sse2.S:190:cannot do signed 4 byte relocation
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end
    
    system "make"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end
end

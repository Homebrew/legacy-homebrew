require 'formula'

class Afsctool <Formula
  url 'http://web.me.com/brkirch/afsctool_34.zip'
  homepage 'http://web.me.com/brkirch/brkirchs_Software/afsctool/afsctool.html'
  md5 'd0f2b79676c0f3d8c22e95fcf859a05f'
  version '1.6.4'

  def install
    ENV.fast
    Dir.chdir "afsctool_34" do
      system "#{ENV.cc} #{ENV.cflags} -lz -framework CoreServices -o afsctool afsctool.c"
      bin.install 'afsctool'
    end
  end
end

require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'http://yaws.hyber.org/download/yaws-1.94.tar.gz'
  sha1 '36295e40bb4db1812901c31d41152f942a63b5cc'

  option "without-yapp", "Omit yaws applications"
  option '32-bit'

  depends_on 'erlang'

  def install
    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch x86_64"
        ENV.append compiler_flag, "-arch i386"
      end
    end

    cd 'yaws' do
      system "./configure", "--prefix=#{prefix}"
      system "make install"

      unless build.include? 'without-yapp'
        cd 'applications/yapp' do
          system "make"
          system "make install"
        end
      end
    end
  end
end

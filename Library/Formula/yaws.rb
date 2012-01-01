require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'http://yaws.hyber.org/download/yaws-1.92.tar.gz'
  md5 'd0c05d2041df79089f7de5d8437ee34b'

  depends_on 'erlang'

  def options
    [
      ["--with-yapp", "Build and install yaws applications"],
      ['--32-bit', "Build 32-bit only."]
    ]
  end

  def install
    if ARGV.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch x86_64"
        ENV.append compiler_flag, "-arch i386"
      end
    end

    Dir.chdir 'yaws' do
      system "./configure", "--prefix=#{prefix}"
      system "make install"

      if ARGV.include? '--with-yapp'
        Dir.chdir 'applications/yapp' do
          system "make"
          system "make install"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    Usually you want to build yapp (yaws applications) as well.
    To do so, use:
      brew install yaws --with-yapp
    EOS
  end
end

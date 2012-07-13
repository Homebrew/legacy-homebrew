require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'http://yaws.hyber.org/download/yaws-1.94.tar.gz'
  sha1 '36295e40bb4db1812901c31d41152f942a63b5cc'

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

    cd 'yaws' do
      system "./configure", "--prefix=#{prefix}"
      system "make install"

      if ARGV.include? '--with-yapp'
        cd 'applications/yapp' do
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

    NOTES
    A) yaws ships with a default configuration that
    expects the following directories to exist:

      #{prefix}/var/log/yaws
      #{lib}/yaws/examples/ebin
      #{lib}/yaws/examples/include

    and will halt if it does not find them.  Either reconfigure

      #{etc}/yaws/yaws.conf

    or create these directories to proceed.

    B) The default configuration will also attempt to host a server 
    on ports 80 and 443 and will fail unless you run yaws 
    interactively as root (sudo yaws -i) or modify yaws.conf.
    EOS
  end
end

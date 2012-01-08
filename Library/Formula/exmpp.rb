require 'formula'

class Exmpp < Formula
  url 'http://download.process-one.net/exmpp/exmpp-0.9.9.tar.gz'
  homepage 'https://support.process-one.net/doc/display/EXMPP/exmpp+home'
  md5 '464b31ff4d709d8abb24cdb063d20c56'

  depends_on 'erlang'

  def options
    [
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

    system "glibtoolize"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
    erlang_lib = (Erlang.new 'erlang').lib + 'erlang/lib'
    erlang_lib.mkpath
    ln_s prefix + "exmpp-#{version}", erlang_lib
  end

  def test
    system "erl", "-noshell",  "-eval",
           "try exmpp_utils:random_id() catch _:_ -> halt(1) end, halt()."
  end
end

require 'brewkit'

class Erlang <Formula
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_src_R13B.tar.gz'
  @md5='6d8c256468a198458b9f08ba6aa1a384'

  def install
    ENV.deparallelize
    system "./configure --disable-debug --prefix='#{prefix}' --enable-kernel-poll --enable-threads --enable-dynamic-ssl-lib --enable-smp-support --enable-hipe"
    system "make"
    system "make install"
  end
end
require 'brewkit'

class ErlangManuals <Formula
  @version='5.7.2'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_doc_man_R13B01.tar.gz'
  @md5='fa8f96159bd9a88aa2fb9e4d79d7affe'
end

class Erlang <Formula
  @version='5.7.2'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_src_R13B01.tar.gz'
  @md5='b3db581de6c13e1ec93d74e54a7b4231'

  depends_on 'icu4c'
  depends_on 'openssl'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--prefix='#{prefix}'",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--enable-smp-support",
                          "--enable-hipe"
    system "make"
    system "make install"
    
    ErlangManuals.new.brew { man.install Dir['man/*'] }
  end
end
require 'brewkit'

class ErlangManuals <Formula
  @version='R13B02-1'
  @homepage='http://www.erlang.org'
  @url='http://www.erlang.org/download/otp_doc_man_R13B02-1.tar.gz'
  @md5='b5f7b20faa049a8b6a753fc7a462d02d'
end

class ErlangHtmlDocs <Formula
  @version='R13B02-1'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_doc_html_R13B02-1.tar.gz'
  @md5='d48da533b49f7b32c94032f2a53c0073'
end

class Erlang <Formula
  @version='R13B02-1'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_src_R13B02-1.tar.gz'
  @md5='2593b9312eb1b15bf23a968743138c52'

  # def patches
  #   [
  #     "http://pastie.org/603456.txt",
  #     "http://pastie.org/603462.txt",
  #     "http://svn.macports.org/repository/macports/trunk/dports/lang/erlang/files/patch-lib-erl_interface-include-ei.h.diff",
  #     "http://svn.macports.org/repository/macports/trunk/dports/lang/erlang/files/patch-lib-erl_interface-src-connect-ei_connect.c.diff",
  #     "http://pastie.org/603469.txt",
  #     "http://pastie.org/603475.txt",
  #     "http://pastie.org/603478.txt",
  #     "http://pastie.org/603480.txt",
  #     "http://pastie.org/603481.txt",
  #     "http://pastie.org/603485.txt"
  #   ]
  # end

  depends_on 'icu4c'
  depends_on 'openssl'

  def install
    ENV.deparallelize
    config_flags = ["--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--enable-smp-support",
                          "--enable-hipe"]

    if Hardware.is_64_bit? and MACOS_VERSION == 10.6
      config_flags << "--enable-darwin-64bit" 
      config_flags << "--enable-m64-build"
    end

    system "./configure", *config_flags
    system "make"
    system "make install"

    ErlangManuals.new.brew { man.install Dir['man/*'] }
    ErlangHtmlDocs.new.brew { doc.install Dir['*'] }
  end
end

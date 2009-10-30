require 'formula'

class ErlangManuals <Formula
  url 'http://www.erlang.org/download/otp_doc_man_R13B02-1.tar.gz'
  md5 'b5f7b20faa049a8b6a753fc7a462d02d'
end

class ErlangHtmlDocs <Formula
  url 'http://erlang.org/download/otp_doc_html_R13B02-1.tar.gz'
  md5 'd48da533b49f7b32c94032f2a53c0073'
end

class Erlang <Formula
  url 'http://erlang.org/download/otp_src_R13B02-1.tar.gz'
  md5 '2593b9312eb1b15bf23a968743138c52'
  version 'R13B02-1'
  homepage 'http://www.erlang.org'

  depends_on 'icu4c'
  skip_clean 'lib'

  def patches
    { :p0 => ["patch-toolbar.erl",
              "patch-erts_emulator_Makefile.in",
              "patch-erts_emulator_hipe_hipe_amd64_asm.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_bifs.m4.diff",
              "patch-erts_emulator_hipe_hipe_amd64_glue.S.diff",
              "patch-erts_emulator_hipe_hipe_amd64.c.diff",
              "patch-erts_emulator_sys_unix_sys_float.c.diff",
              "patch-erts_configure.diff",
              "patch-lib_ssl_c_src_esock_openssl.c",
              "patch-lib_wx_configure.in",
              "patch-lib_wx_configure"
            ].map { |file_name| "http://svn.macports.org/repository/macports/!svn/bc/60054/trunk/dports/lang/erlang/files/#{file_name}" }
    }
  end

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
    system "touch lib/wx/SKIP"
    system "make"
    system "make install"

    ErlangManuals.new.brew { man.install Dir['man/*'] }
    #ErlangHtmlDocs.new.brew { doc.install Dir['*'] }
  end
end

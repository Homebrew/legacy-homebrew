require 'formula'

class Pjsip < Formula
  homepage 'http://www.pjsip.org'
  url 'http://www.pjsip.org/release/2.2/pjproject-2.2.tar.bz2'
  sha1 '156212ba738e0f9029aff9e59a9083579b05457d'

  head "http://svn.pjsip.org/repos/pjproject/trunk"

  option "use-bundled-libs", "Use bundled libs for third party dependencies"
  option "disable-shared", "Disable building shared libs"

  depends_on 'openssl'

  unless build.include? "use-bundled-libs"
    depends_on 'libgsm'
    depends_on 'portaudio'
    depends_on 'speex'
    depends_on 'srtp'
  end

  def install
    ENV.j1

    openssl = Formula['openssl']

    args = ["--prefix=#{prefix}",
            "--with-ssl=#{openssl.opt_prefix}"]

    # PJSIP's resample library conflicts with libresample
    args << "--disable-resample"

    # opencore support isn't working
    args << "--disable-opencore-amr"

    unless build.include? "use-bundled-libs"
      args << "--with-external-speex"
      args << "--with-external-srtp"
      args << "--with-external-gsm"
      args << "--with-external-pa"
    end

    args << "--enable-shared" unless build.include? "disable-shared"

    system "./configure", *args

    Pathname('pjlib/include/pj/config_site.h').write <<-EOS.undent
      /* config_site_sample.h fails with GCC 4.8 without these defines */
      #define PJ_CONFIG_IPHONE 0
      #define PJ_CONFIG_ANDROID 0

      #define PJ_CONFIG_MAXIMUM_SPEED
      #include <pj/config_site_sample.h>

      #ifndef FD_SETSIZE
        #include <sys/types.h>
      #endif

      #if PJ_IOQUEUE_MAX_HANDLES>FD_SETSIZE
        #undef PJ_IOQUEUE_MAX_HANDLES
        #define PJ_IOQUEUE_MAX_HANDLES     FD_SETSIZE
      #endif

      #undef PJSUA_MAX_CALLS
      #define PJSUA_MAX_CALLS              1024
      #define PJSUA_MAX_PLAYERS            1024
      #define PJSUA_MAX_RECORDERS          1024
      #define PJSUA_MAX_CONF_PORTS         (PJSUA_MAX_CALLS+PJSUA_MAX_PLAYERS+PJSUA_MAX_RECORDERS)
      /* libsrtp is a shared lib by default on OS X, no init/deinit needed */
      #define PJMEDIA_LIBSRTP_AUTO_INIT_DEINIT 0
    EOS
    system "make", "dep"
    system "make"
    system "make", "install"
  end
end

require 'formula'

class Opal < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/opal/3.10/opal-3.10.1.tar.bz2'
  homepage 'http://wiki.ekiga.org/'
  md5 'eda49f2c0c3649fab8b82aca0c499b1a'

  depends_on 'ptlib'

  def install
    #system "./configure --help ; exit 32"
    ptlib_prefix = Formula.factory('ptlib').prefix
    system "./configure",
      "--with-ptlib-dir=#{ptlib_prefix}",
      "--with-ptlib-includedir=#{ptlib_prefix}/include",
      "--with-ptlib-libdir=#{ptlib_prefix}/lib",
      "--enable-versioncheck",   # enable ptlib versioncheck
      "--enable-localspeexdsp",  # Force use local version of Speex DSP library for
                                 # echo cancellation rather than system version
      "--enable-zrtp",           # enable ZRTP protocol support
      "--enable-srtp",           # enable SRTP protocol support
      "--enable-capi",           # enable CAPI
      "--enable-java",           # enable Java JNI support
      "--enable-ruby",           # enable Ruby support
      "--enable-video",          # whether to enable video codec support
      "--enable-sip",            # whether to enable SIP protocol support
      "--enable-h323",           # whether to enable H.323 protocol support
      "--enable-iax2",           # whether to enable IAX2 protocol support
      "--enable-h224",           # whether to enable H.224 protocol support
      "--enable-h281",           # whether to enable H.281 (Far End Camera Control)
                                 # protocol support
      "--enable-t38",            # whether to enable T.38 capability support
      "--enable-msrp",           # whether to enable MSRP support
      "--enable-sipim",          # whether to enable SIPIM session support
      "--enable-rfc4103",        # whether to enable RFC4103 support
      "--enable-fax",            # whether to enable T.38 FAX protocol support
      "--enable-h450",           # whether to enable H.450
      "--enable-h460",           # whether to enable H.460
      "--enable-h239",           # whether to enable H.239
      "--enable-h501",           # whether to enable H.501
      "--enable-t120",           # whether to enable T.120
      "--enable-lid",            # whether to enable LID support
      "--enable-ivr",            # whether to enable IVR support
      "--enable-rfc4175",        # whether to enable RFC4175 support
      "--enable-rfc2435",        # whether to enable RFC2435 support (experimental)
      "--enable-aec",            # whether to enable accoustic echo cancellation
                                 # support
      "--enable-g711plc",        # whether to enable Packet Loss Concealment for G.711
      "--enable-rtcpxr",         # whether to enable RTCP Extended Reports support
      "--enable-statistics",     # whether to enable statistics gathering support
      "--enable-mixer",          # whether to enable media mixing support
      "--enable-pcss",           # whether to enable PC sound system support
      "--enable-plugins",        # whether to enable plugin support
      "--enable-samples",        # whether to enable samples build

      "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

end

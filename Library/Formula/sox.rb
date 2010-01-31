require 'formula'

class Sox <Formula
  url 'http://downloads.sourceforge.net/project/sox/sox/14.3.0/sox-14.3.0.tar.gz'
  homepage 'http://sox.sourceforge.net/'
  md5 '8e3509804e6227273ef84092e1a2fea7'

  depends_on 'libvorbis' => :optional

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]
    # Linking error 'symbol not found' on 10.6 64-bit '"_gomp_thread_attr", referenced from:'
    configure_args << "--disable-gomp"

    system "./configure", *configure_args
    system "make install"
  end
end

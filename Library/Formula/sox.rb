require 'formula'

class Sox <Formula
  url 'http://downloads.sourceforge.net/project/sox/sox/14.3.1/sox-14.3.1.tar.gz'
  homepage 'http://sox.sourceforge.net/'
  md5 'b99871c7bbae84feac9d0d1f010331ba'

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

require 'formula'

class Libcanberra < Formula
  homepage 'http://0pointer.de/lennart/projects/libcanberra/'
  url 'http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz'
  sha1 'fd4c16e341ffc456d688ed3462930d17ca6f6c20'

  head 'git://git.0pointer.de/libcanberra'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build

  depends_on 'libvorbis'

  depends_on 'pulseaudio' => :optional
  depends_on 'gstreamer' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'gtk+3' => :optional

  def patches
    # Remove --as-needed and --gc-sections linker flag as it causes linking to fail
    { :p0 => [
      'https://trac.macports.org/export/104881/trunk/dports/audio/libcanberra/files/patch-configure.diff'
    ]}
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install" 
  end
end


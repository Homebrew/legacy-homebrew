require "formula"

class Libcanberra < Formula
  homepage "http://0pointer.de/lennart/projects/libcanberra/"
  head "git://git.0pointer.de/libcanberra"
  url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
  sha1 "fd4c16e341ffc456d688ed3462930d17ca6f6c20"

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "pulseaudio" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional

  # Remove --as-needed and --gc-sections linker flag as it causes linking to fail
  patch :p0 do
    url "https://trac.macports.org/export/104881/trunk/dports/audio/libcanberra/files/patch-configure.diff"
    sha1 "a3cd66c64d26c871c724a9ff54b2c5f7199daf2c"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

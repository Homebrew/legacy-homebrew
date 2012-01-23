require 'formula'

#
# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs
#

class Gpac < Formula
  url 'http://downloads.sourceforge.net/gpac/gpac-0.4.5.tar.gz'
  homepage 'http://gpac.sourceforge.net/index.php'
  md5 '755e8c438a48ebdb13525dd491f5b0d1'
  head 'https://gpac.svn.sourceforge.net/svnroot/gpac/trunk/gpac', :using => :svn

  depends_on 'a52dec' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'faad2' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'mad' => :optional
  depends_on 'sdl' => :optional
  depends_on 'theora' => :optional

  depends_on 'ffmpeg' => :optional if ARGV.build_head?
  depends_on 'openjpeg' => :optional if ARGV.build_head?

  def options
    [['--with-lowercase', 'Install binaries with lowercase names']]
  end

  def install
    ENV.deparallelize
    args = ["--disable-wx",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            # Force detection of X libs on 64-bit kernel
            "--extra-ldflags=-L/usr/X11/lib"]
    args << "--use-ffmpeg=no" unless ARGV.build_head?
    args << "--use-openjpeg=no" unless ARGV.build_head?

    system "chmod +x configure"
    system "./configure", *args

    system "chmod", "+rw", "Makefile"
    ["MP4Box","MP4Client"].each do |name|
      filename = "applications/#{name.downcase}/Makefile"
      system "chmod", "+rw", filename

      if ARGV.include? '--with-lowercase'
        inreplace filename, name, name.downcase
        inreplace "Makefile", name, name.downcase
      end
    end

    system "make"
    system "make install"
  end
end

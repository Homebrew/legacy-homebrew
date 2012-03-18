require 'formula'

class Pulseaudio < Formula
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-1.1.tar.gz'
  head 'git://anongit.freedesktop.org/pulseaudio/pulseaudio'
  homepage 'http://pulseaudio.org'
  md5 '1b76932ca7c4b2aa992941e41ed4594b'
  
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'libsndfile'
  depends_on 'speex'
  depends_on 'json-c'
  depends_on 'libsamplerate'

  def install
    args = ["--prefix=#{prefix}",
            "--with-udev-rules-dir=#{prefix}/lib/udev/rules.d"]
    
    if !File.exists? "/Developer/SDKs/MacOSX10.5.sdk" then
      # Does not seem to build correctly with 10.6 SDK (hence the and false)
      if File.exists? "/Developer/SDKs/MacOSX10.6.sdk" and false then
        args << "--with-mac-sysroot=/Developer/SDKs/MacOSX10.6.sdk"
        args << "--with-mac-version-min=10.6"
      elsif File.exists? "/Developer/SDKs/MacOSX10.7.sdk" then
        args << "--with-mac-sysroot=/Developer/SDKs/MacOSX10.7.sdk"
        args << "--with-mac-version-min=10.7"
      else
        onoe "Error! Cannot find Mac OS X SDK"
      end
    end 
    
    if ARGV.build_head? then
      system "./autogen.sh"
    end
    
    system "./configure", *args
    system "make install"
  end

  def test
    system "pulseaudio"
  end
end



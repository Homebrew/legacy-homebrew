require 'formula'

class Tinyos < Formula
  url 'http://tinyos-main.googlecode.com/svn/tags/release_tinyos_2_1_1_3', :using => :svn
  head 'http://tinyos-main.googlecode.com/svn/trunk/', :using => :svn
  homepage 'http://wyww.tinyos.net/'
  version '2.1.1'

  depends_on 'nesc'

  def install
    #change to tools directory - this is where the build takes place
    Dir.chdir("tools")

    #update the JDK path location so that jni.h can be found
     inreplace 'tinyos/misc/tos-locate-jre' do |s|
       s.gsub! '/Versions/CurrentJDK', ''
     end

    #bootstrap and configure the install
    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make the tinyos tools.  do it step by step
    ENV.deparallelize
    ENV.no_optimization
    system "make"  # separate make and make install steps
    system "make install"

    # change back to the working directory and install everything by copying over
    Dir.chdir("..")
    prefix.install Dir['*']

    def caveats
      "Installing AVR through homebrew doesn't yet work: instead install CrossPack from:
        http://www.obdev.at/products/crosspack/download.html

      After installation, configure CrossPack to use AVR version 3:
        avr-gcc-select 3

      Add the following entries to your .bashrc or .bash_profile:
        export TOSROOT=#{prefix}
        export TOSDIR=#{prefix}/tos
        export MAKERULES=#{prefix}/support/make/Makerules"
    end
  end
end
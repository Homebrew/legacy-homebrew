require 'formula'

class Simh <Formula
  url 'http://simh.trailing-edge.com/sources/simhv38-1.zip'
  version '3.8-1'
  homepage 'http://simh.trailing-edge.com/'
  md5 'e15f65a82e21ea49e14b438326d93d5c'

  def install
    ENV['OSTYPE'] = 'darwin'
    mkdir 'BIN'
    inreplace "makefile" do |s|
      # Note: change_make_var! doesn't work for this makefile
      s.gsub! "NETWORK_OPT = -DUSE_NETWORK -isystem /usr/local/include /usr/local/lib/libpcap.a",
              "NETWORK_OPT = -DUSE_NETWORK -lpcap"

      # Use our compiler & flags, and don't create dSYMs.
      s.gsub! "CC = gcc -std=c99 -U__STRICT_ANSI__ -g $(OS_CCDEFS) -I .",
              "CC = #{ENV.cc} #{ENV.cflags} -std=c99 -U__STRICT_ANSI__ $(OS_CCDEFS) -I ."
    end
    system "make USE_NETWORK=1 all"
    bin.install Dir['BIN/*']
  end
end

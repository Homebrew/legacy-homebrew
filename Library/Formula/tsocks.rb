require 'formula'

class Tsocks < Formula
  # The original is http://tsocks.sourceforge.net/
  # This GitHub repo is a maintained fork with OSX support
  head 'git://github.com/pc/tsocks.git'
  version '1.9'
  homepage 'http://github.com/pc/tsocks'
  md5 'ecb2d291b475122391488f063d17db02'

  def config_file
    etc / 'tsocks.conf'
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-conf=#{config_file}"

    inreplace("tsocks") { |bin| bin.change_make_var! "LIBDIR", lib }

    system "make"
    system "make install"

    etc.install "tsocks.conf.simple.example" => "tsocks.conf" unless config_file.exist?
  end

  def test
    puts 'Your current public ip is:'
    ohai `curl -sS ifconfig.me 2>&1`.chomp
    puts "If your correctly configured #{config_file}, this should show the ip you have trough the proxy"
    puts 'Your ip through the proxy is:'
    ohai `tsocks curl -sS ifconfig.me 2>&1`.chomp
  end
end
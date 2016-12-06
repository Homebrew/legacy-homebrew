require 'formula'

class Olsrd < Formula
  homepage 'http://www.olsr.org'
  url 'http://www.olsr.org/releases/0.6/olsrd-0.6.4.tar.bz2'
  sha1 '9a21400e7a97c685283a4e19850b88ada32bfd9c'

  def install
    custom_vars = %W[DESTDIR=#{prefix} USRDIR=#{prefix} LIBDIR=#{lib}]
    # running make install without build_all will fail
    system "make", "build_all", *custom_vars
    lib.mkpath
    system "make", "install_all", *custom_vars
  end

  def caveats; <<-EOS.undent
    Olsrd uses /etc/olsrd.conf as default configfile.
    Please use olsrd -f #{prefix}/etc/olsrd.conf to run it.
    EOS
  end

  def test
    File.executable?("#{sbin}/olsrd")
    File.file?("#{etc}/olsrd.conf")
    # Not needed for running, but helpful nevertheless
    File.file?("#{man8}/olsrd.8.gz")
    File.file?("#{man5}/olsrd.conf.5.gz")
    plugins = Dir.glob("#{lib}/*.so.*")
    plugins.count > 0
  end
end

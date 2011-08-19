require 'formula'

class Robodoc < Formula
  homepage 'http://rfsber.home.xs4all.nl/Robo/index.html'
  url 'http://rfsber.home.xs4all.nl/Robo/robodoc-4.99.41.tar.gz'
  md5 '986ff954e0ba5a9c407384fc4b05303d'

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end


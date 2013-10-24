# encoding: UTF-8

require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/archive/10.0.tar.gz'
  sha1 'cc5ad82723f989f93edf8ab83e36a7e89763649c'

  head 'https://github.com/buganini/bsdconv.git'

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/bsdconv", "big5:utf-8") do |stdin, stdout, _|
      stdin.write("\263\134\245\134\273\134")
      stdin.close
      assert_equal "許功蓋", stdout.read
    end
  end
end

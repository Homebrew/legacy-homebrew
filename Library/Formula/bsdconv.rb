# encoding: UTF-8

require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/archive/11.1.tar.gz'
  sha1 'd2dd2e94fd013d2d7cfa4d55ebff0bd6a7c5c244'

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

# encoding: UTF-8

require 'formula'

class Bsdconv < Formula
  homepage 'https://github.com/buganini/bsdconv'
  url 'https://github.com/buganini/bsdconv/archive/11.3.1.tar.gz'
  sha1 'cec116e2a13b85abafa15011301fb539d2fd5244'

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
      result = stdout.read
      result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
      assert_equal "許功蓋", result
    end
  end
end

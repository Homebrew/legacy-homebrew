class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.3.1.tar.gz"
  sha256 "b0656011fd40ec440e9966bba44d330a6213fdd198c487c87bc61869ef7fea9e"

  head "https://github.com/buganini/bsdconv.git"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/bsdconv", "big5:utf-8") do |stdin, stdout, _|
      stdin.write("\263\134\245\134\273\134")
      stdin.close
      result = stdout.read
      result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
      assert_equal "許功蓋", result
    end
  end
end

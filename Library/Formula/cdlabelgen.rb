require 'formula'

class Cdlabelgen < Formula
  homepage 'http://www.aczoom.com/tools/cdinsert/'
  url 'http://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz'
  sha1 '1f7e1c34f7a5f409da19ca768a07778191264b19'

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system "#{bin}/cdlabelgen -c TestTitle --output-file testout.eps"
    File.file?("testout.eps")
  end
end

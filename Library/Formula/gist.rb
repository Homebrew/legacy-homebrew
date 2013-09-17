require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/archive/v4.1.1.tar.gz'
  sha1 '47c9708acd56fb2e7cd463b607a5dd12b9a77235'
  head 'https://github.com/defunkt/gist.git'

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", '--version'
  end
end

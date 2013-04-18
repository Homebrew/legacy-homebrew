require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/archive/v3.1.0.tar.gz'
  sha1 'ae524b79c2321779e2553a7847fab82f178e8ffc'
  head 'https://github.com/defunkt/gist.git'

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", '--version'
  end
end

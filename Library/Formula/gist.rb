require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/archive/v4.0.3.tar.gz'
  sha1 '4c88ac3550833154beab134d7ccc9ec8330ad281'
  head 'https://github.com/defunkt/gist.git'

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", '--version'
  end
end

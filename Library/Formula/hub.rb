require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.1'
  homepage 'https://github.com/defunkt/hub#readme'
  head 'https://github.com/defunkt/hub.git'
  md5 'e552caf1af3b4d007fd5d19ef25cc682'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

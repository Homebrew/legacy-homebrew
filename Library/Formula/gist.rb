require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/archive/85f7b59b2805ba69c175a4003c46e7e47fe78ebc.tar.gz'
  version '4.0.0-pre'
  sha1 '6cf1f5dd63a9704544d6bdb4d76162e9573fdf61'
  head 'https://github.com/defunkt/gist.git'

  def install
    prefix.install 'bin', 'lib'
  end

  test do
    system "#{bin}/gist", '--version'
  end
end

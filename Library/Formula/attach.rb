require 'formula'

class Attach < Formula
  url 'https://github.com/sorin-ionescu/attach/tarball/1.0.6'
  head 'https://github.com/sorin-ionescu/attach.git'
  homepage 'http://github.com/sorin-ionescu/attach'
  md5 '3f59637359072f8614575b3e3e638bc4'

  depends_on 'dtach'

  def install
    bin.install 'attach'
    man1.install 'attach.1'
  end
end


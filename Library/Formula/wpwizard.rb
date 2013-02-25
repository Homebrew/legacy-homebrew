require 'formula'

class Wpwizard < Formula
  homepage 'https://github.com/bradp/wpWizard'
  url 'https://github.com/bradp/wpWizard/archive/master.zip'
  sha1 '74af9557d51d74b7201d50d987bad648719a0a86'
  version '1.0.1'
  def install
    system "ln -s wpwizard /usr/local/sbin/"
  end
end

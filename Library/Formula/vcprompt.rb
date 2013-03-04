require 'formula'

class Vcprompt < Formula
  homepage 'https://bitbucket.org/gward/vcprompt'
  url 'https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.0.tar.gz'
  version '1.0'
  sha1 'a393d06a3b6030a822af53c985b6a170265ee901'

  head 'hg://https://bitbucket.org/gward/vcprompt'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end

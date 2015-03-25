require 'formula'

class Joe < Formula
  homepage 'http://joe-editor.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.0/joe-4.0.tar.gz'
  sha1 'a51827c8c61c3cb09a038d8f6670efe84e144927'

  bottle do
    sha256 "d6739911e38e9017999136d04c9b852110f2d625cd6048188d2618f072aaec0b" => :yosemite
    sha256 "4a7b57c3bf747ba2814f18a5f0b2a53ef005c0686b8c7c9650db67961cf384f8" => :mavericks
    sha256 "d7b0e974e3c23620df690dbbde753f87008112981b26c3166ea845d29d28a81e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

end

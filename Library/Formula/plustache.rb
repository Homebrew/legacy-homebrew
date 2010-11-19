require 'formula'

class Plustache <Formula
  url 'https://github.com/mrtazz/plustache/tarball/v0.2.0'
  homepage 'https://github.com/mrtazz/plustache'
  md5 '85b7a895ee2a023a1c8f4c09fb41b179'

  depends_on 'boost'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

require 'formula'

class Kjell < Formula
  homepage 'http://karlll.github.io/kjell/'
  url 'https://github.com/karlll/kjell.git', :tag => '0.2.2'
  sha1 '514fc79b62093edd4149b9d1ab54874d4e9e3fae'

  depends_on "erlang"

  def install
    system "make"
    system "make", "configure", "PREFIX=#{prefix}"
    system "make", "install", "NO_SYMLINK=1"
    system "make", "install-extensions"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/kjell") do |stdin, stdout, _|
      stdin.write("q().\n")
      stdin.close
    end
  end

  def caveats
    "Extension kjell-prompt requires a powerline patched font. See https://github.com/Lokaltog/powerline-fonts"
  end

end

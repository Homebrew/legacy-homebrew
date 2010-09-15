require 'formula'

class Mono <Formula
  url "git://github.com/mono/mono.git", :tag => "mono-2-6-7"
  head "git://github.com/mono/mono.git"
  homepage "http://mono-project.com/"
  version "2.6.7"

  depends_on "pkg-config"

  def install
    system "./autogen.sh", "--prefix=#{prefix}",
                           "--with-glib=embedded",
                           "--enable-nls=no"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to build and install Mono you need to have a regular Mono instalation. You can
    get this from:
        http://www.go-mono.com/mono-downloads/download.html

    After installation, if you want to make it the default installation to the system, you
    can do this by:
        cd /Library/Frameworks/Mono.framework/Versions
        sudo ln -s /usr/local/Cellar/mono/#{version} brew
        sudo rm Current
        sudo ln -s brew Current 
    EOS
  end
end
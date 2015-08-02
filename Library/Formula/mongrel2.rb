require 'formula'

class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/releases/download/1.9.2/mongrel2-v1.9.2.tar.bz2'
  sha1 '1b44d8028bba7f427cfda3fc7bf6c4350d810a75'
  revision 1

  head 'https://github.com/zedshaw/mongrel2.git'

  bottle do
    cellar :any
    sha256 "7179e51d48d93b723cb7b047ab541a43ade6f2e55f603be55e44a7f342af4f05" => :yosemite
    sha256 "508cea44a7cb7705a2b03f804ef4a23d55ad96e2ff0987a36aaca3582200adf7" => :mavericks
    sha256 "8c61454fa2ff553a83faae91b0085b4b613175fe41f3574f81ebd7d4ae2ec93c" => :mountain_lion
  end

  depends_on 'zeromq'

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV['OPTFLAGS'] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV['OPTLIBS'] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make all"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

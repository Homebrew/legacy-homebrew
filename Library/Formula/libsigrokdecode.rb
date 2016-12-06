require 'formula'

class NeedsPython3 < Requirement

  # looks for python3-config
  def satisfied?
    ENV['PATH'].split(':').each do |path|
      return true if File.executable? "#{path}/python3-config"
    end
    return false
  end

  def fatal?
    true
  end

  def message; <<-EOS.undent
    This library depends on Python version 3 but python3-config
    was not found on your PATH.
    You can install a python3 distribution using:
      brew install python3
    EOS
  end
end

class Libsigrokdecode < Formula
  homepage 'http://sigrok.org'
  url 'http://downloads.sourceforge.net/project/sigrok/source/libsigrokdecode/libsigrokdecode-0.1.0.tar.gz'
  md5 '9bc237972f6176ba9dcff057b4e85fd6'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  # libsigrokdecode needs python3!
  depends_on NeedsPython3.new

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

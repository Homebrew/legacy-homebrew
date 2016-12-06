require 'formula'

class Tal < Formula
  homepage 'http://thomasjensen.com/software/tal/'
  url 'http://thomasjensen.com/software/tal/tal-1.9.tar.gz'
  md5 'a22e53f5f0d701a408e98e480311700b'

  def install
      system "make linux"
      system "install -d #{bin}"
      system "install tal #{bin}"
      system "install -d #{man1}"
      system "install -m 0644 tal.1 #{man1}"
      system "install -m 0644 LICENSE #{prefix}"
  end

  def test
    system "tal /etc/passwd"
  end
end

require 'formula'

class Aescrypt < Formula
  homepage 'http://aescrypt.sourceforge.net/'
  url 'http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz'
  sha1 '72756ccccd43a4f19796835395512616c86c273f'

  def install
    system "./configure"
    system "make"
    bin.install "aescrypt", "aesget"
  end

  test do
    (testpath/"key").write "kk=12345678901234567890123456789abc0"

    require "open3"
    Open3.popen3("#{bin}/aescrypt", "-k", testpath/"key") do |stdin, stdout, _|
      stdin.write("hello")
      stdin.close
      # we can't predict the output
      stdout.read.length > 0
    end
  end
end

require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://bitbucket.org/neilb/csvfix/get/version-1.5.zip'
  sha1 '03381517e37dcd18926dca577d117732d65f0e27'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end

  test do
    IO.popen("#{bin}/csvfix trim", "w+") do |pipe|
      pipe.write "foo , bar \n"
      pipe.close_write
      assert_equal %{"foo","bar"\n}, pipe.read
    end
  end
end

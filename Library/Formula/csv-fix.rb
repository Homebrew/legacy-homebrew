require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://bitbucket.org/neilb/csvfix/get/version-1.3.zip'
  sha1 '2bca2d461434e7bd799e6c886d8eda769e7d3937'

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

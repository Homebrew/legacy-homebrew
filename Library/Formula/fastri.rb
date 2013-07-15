require 'formula'

class Fastri < Formula
  homepage 'http://eigenclass.org/hiki/fastri'
  url 'http://rubyforge.org/frs/download.php/31654/fastri-0.3.1.tar.gz'
  sha1 '171f6237b29591748118cdc2a8e15cba256c12cc'

  def install
    system "ruby", "setup.rb", "all", "--prefix=#{prefix}"
  end
end

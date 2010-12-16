require 'formula'

class Fastri <Formula
  homepage 'http://eigenclass.org/hiki/fastri'
  url 'http://rubyforge.org/frs/download.php/31654/fastri-0.3.1.tar.gz'
  md5 '3a7d0a64b1c8e230a34ef7b4bad30dbe'

  def install
    system "ruby setup.rb all --prefix='#{prefix}'"
  end
end
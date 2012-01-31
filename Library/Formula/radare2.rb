require 'formula'

class Radare2 < Formula
  url 'http://radare.org/get/radare2-0.9.tar.gz'
  head 'http://radare.org/hg/radare2', :using => :hg
  homepage 'http://radare.org'
  md5 '751f0dc71f82b7689f10365ee3a5842f'

  depends_on 'libewf' unless ARGV.include? '--without-ewf'
  depends_on 'gmp'    unless ARGV.include? '--without-gmp'
  depends_on 'libmagic'
  depends_on 'lua'

  def options
    [
      ['--without-ewf','Disable libewf dependency'],
      ['--without-gmp','Disable libgmp dependency']
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << '--without-ewf' if ARGV.include? '--without-ewf'
    args << '--without-gmp' if ARGV.include? '--without-gmp'
    system "./configure", *args
    system "make"
    system "make install"
  end
end

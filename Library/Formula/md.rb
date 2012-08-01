require 'formula'

class Md < Formula
  homepage 'http://opensource.apple.com/source/adv_cmds/adv_cmds-147/md/'
  url 'http://opensource.apple.com/tarballs/adv_cmds/adv_cmds-147.tar.gz'
  sha1 '0128de65a4da2ef9655f3b1e6a94d2f8ae292414'

  # OS X up to and including Lion 10.7 includes 'md'
  keg_only :provided_by_osx unless MacOS.mountain_lion?

  def install
    cd 'md' do
      system "#{ENV.cc} #{ENV.cflags} -o md md.c"
      bin.install('md')
      man1.install('md.1')
    end
  end
end

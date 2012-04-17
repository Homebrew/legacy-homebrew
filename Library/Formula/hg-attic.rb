require 'formula'

class HgAttic < Formula
  homepage 'https://bitbucket.org/Bill_Barry/hgattic'
  url 'https://bitbucket.org/Bill_Barry/hgattic/get/1.0.1.tar.bz2'
  md5 'd2f7294d72c6a26073f1088a8caf7358'

  head "https://bitbucket.org/Bill_Barry/hgattic", :using => :hg

  def install
    prefix.install 'attic.py'
  end

  def caveats; <<-EOS.undent
    1. Put following lines into your ~/.hgrc
    2. For more information go to https://bitbucket.org/Bill_Barry/hgattic/

    [extensions]
        hgattic = #{prefix}/attic.py
    EOS
  end
end

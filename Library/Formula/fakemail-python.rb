require 'formula'

class FakemailPython < Formula
  homepage 'http://www.lastcraft.com/fakemail.php'
  url 'http://downloads.sourceforge.net/project/fakemail/fakemail-python/1.0/fakemail-python-1.0.tar.gz'
  md5 'a9501bc6a4045ff7e67ad5017a2bb06f'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}" 
  end

  def test
    system "true"
  end
end

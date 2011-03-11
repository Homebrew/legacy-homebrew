require 'formula'

class Memtester <Formula
  url 'http://pyropus.ca/software/memtester/old-versions/memtester-4.2.1.tar.gz'
  homepage 'http://pyropus.ca/software/memtester/'
  md5 '070ced84da42060d65489e6dc1a4211a'

  # depends_on 'cmake'

  def install
    system "make install"
  end
end

require 'formula'

class Duply <Formula
  url 'http://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.2.3.tgz'
  homepage 'http://duply.net'
  md5 '7bb3af2219ba6c4dfe06856fbecbef8f'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end

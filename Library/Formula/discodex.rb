require 'formula'

class Discodex < Formula
  homepage 'https://github.com/discoproject/discodex'
  url 'https://github.com/discoproject/discodex/archive/fa3fa57aa9fcd9c2bd3b4cd2233dc0d051dafc2b.tar.gz'
  sha1 '03a9ce7a8d70c371f4dd3ce2a1e2c72cda1fc1f4'
  # No tags in the project; using date of last commit as a proxy
  version '2012-01-10'

  depends_on 'disco'

  def install

    system "make install prefix=#{prefix}"

    # The make target only installs python libs; must manually install the rest
    prefix.install(%w[bin doc])
  end

end

require 'formula'

class LessJs <Formula
  url 'git://github.com/cloudhead/less.js.git', :tag => '7996bf5e78486f5f1bc00ce9a1b4f649df332564'
  head 'git://github.com/cloudhead/less.js.git'
  homepage 'http://github.com/cloudhead/less.js'
  md5 ''
  version '1.0.35'

  depends_on 'node'

  def install
    prefix.install Dir['*']
  end
end

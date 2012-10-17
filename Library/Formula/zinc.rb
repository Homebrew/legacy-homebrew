require 'formula'

class Zinc < Formula
  homepage 'https://github.com/typesafehub/zinc'
  url 'http://repo.typesafe.com/typesafe/zinc/com/typesafe/zinc/dist/0.1.4/zinc-0.1.4.tgz'
  sha1 '5b89a87118c00c023b66403cc91d2c6f8c0f7e27'

  def install
    rm_f Dir["bin/ng/linux*"]
    rm_f Dir["bin/ng/win*"]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/zinc"]
  end

end

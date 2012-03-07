require 'formula'

class Ldid < Formula
  head 'https://github.com/rpetrich/ldid.git'
  homepage 'https://github.com/rpetrich/ldid'

  def install
    system "sh make.sh"
    bin.install ["ldid"]
  end
end


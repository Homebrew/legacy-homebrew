require 'formula'

class Ioke <Formula
  url 'http://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz'
  homepage 'http://ioke.org/'
  md5 '936fac215d14809ff5f4bd1fd8262ce0'

  def install
    inreplace 'bin/ioke' do |s|
      s.change_make_var! 'IOKE_HOME', HOMEBREW_PREFIX
    end

    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin lib share]
  end
end
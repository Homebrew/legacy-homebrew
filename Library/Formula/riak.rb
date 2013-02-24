require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.0/osx/10.6/riak-1.3.0-osx-x86_64.tar.gz'
    version '1.3.0-x86_64'
    sha256 '912d724393253583b23df70b695eb6fb56838e3d35eeef8a2fb5360acf55bff9'
  else
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.0/osx/10.6/riak-1.3.0-osx-i386.tar.gz'
    version '1.3.0-i386'
    sha256 '278454d8d0a08602b6b0c3d3c6e1d9f051fe2115f4c439663cc4b5ac65bdf2c5'
  end

  skip_clean 'libexec'

  option '32-bit'

  def install
    libexec.install Dir['*']

    # The scripts don't dereference symlinks correctly.
    # Help them find stuff in libexec. - @adamv
    inreplace Dir["#{libexec}/bin/*"] do |s|
      s.change_make_var! "RUNNER_SCRIPT_DIR", "#{libexec}/bin"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end

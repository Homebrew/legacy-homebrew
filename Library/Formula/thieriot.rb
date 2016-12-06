require 'formula'

class Thieriot < Formula
  homepage 'http://rodnaph.github.com/thieriot/'
  url 'https://github.com/rodnaph/thieriot/archive/v1.1.0.tar.gz'
  sha1 '979a916d977141847f2061cb10fe685965b3d641'

  def install
    bin.install "trt"
  end

  def caveats; <<-EOS.undent
    Thieriot requires the following Perl modules, available from
    CPAN with the following command:

      cpan -i YAML JSON LWP::UserAgent
    EOS
  end
end


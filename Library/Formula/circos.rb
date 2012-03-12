require 'formula'

class Circos < Formula
  homepage 'http://circos.ca/'
  url 'http://circos.ca/distribution/circos-0.56.tgz'
  md5 '1dd2c3d254264c5a874e4470fef3d138'

  depends_on 'gd'

  depends_on 'Carp' => :perl
  depends_on 'Config::General' => :perl
  depends_on 'Cwd' => :perl
  depends_on 'Data::Dumper' => :perl
  depends_on 'Digest::MD5' => :perl
  depends_on 'File::Basename' => :perl
  depends_on 'File::Spec::Functions' => :perl
  depends_on 'File::Temp' => :perl
  depends_on 'FindBin' => :perl
  depends_on 'GD' => :perl
  depends_on 'GD::Image' => :perl
  depends_on 'GD::Polyline' => :perl
  depends_on 'Getopt::Long' => :perl
  depends_on 'IO::File' => :perl
  depends_on 'List::MoreUtils' => :perl
  depends_on 'List::Util' => :perl
  depends_on 'Math::Bezier' => :perl
  depends_on 'Math::BigFloat' => :perl
  depends_on 'Math::Round' => :perl
  depends_on 'Math::VecStat' => :perl
  depends_on 'Memoize' => :perl
  depends_on 'POSIX' => :perl
  depends_on 'Params::Validate' => :perl
  depends_on 'Pod::Usage' => :perl
  depends_on 'Readonly' => :perl
  depends_on 'Regexp::Common' => :perl
  depends_on 'Set::IntSpan' => :perl
  depends_on 'Storable' => :perl
  depends_on 'Sys::Hostname' => :perl
  depends_on 'Text::Format' => :perl
  depends_on 'Time::HiRes' => :perl

  def install

    # change /bin/env to /usr/bin/env
    inreplace ["bin/circos","bin/gddiag","etc/makehuesteps"] do |s|
      s.gsub! "/bin/env", "/usr/bin/env"
    end

    # install missing perl modules
    # NB: this currently has to be done by the user because homebrew does not install those
    #     https://github.com/mxcl/homebrew/wiki/Gems,-Eggs-and-Perl-Modules

    # just link everything
    prefix.install Dir['*']
  end

  def test
    # Test the generation of a graphic and display the result
    ohai "Testing perl module dependencies"
    s = `cd #{bin} && ./test.modules`
    print s
    ohai "Install missing ones with \`sudo cpan <module name>\`"
    ohai "Currently the installation of GD has to be forced with"
    print "  sudo perl -MCPAN -e \"CPAN::Shell->force(qw(install GD));\"\n"

    system "cd #{prefix}/example && circos -conf etc/circos.conf && open circos.png"
  end
end
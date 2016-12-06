require 'formula'

class JohnJumbo < Formula
  url 'http://www.openwall.com/john/g/john-1.7.8-jumbo-7.tar.gz'
  homepage 'http://www.openwall.com/john'
  md5 'd9e55ce5c756436259f4c62bb237474b'
  version '1.7.8-jumbo7'

  def install
    inreplace 'src/params.h',
      /^#define CFG_FULL_NAME[ 	].*$/,
      "#define CFG_FULL_NAME	\"#{etc}/john.conf\""

    ENV.deparallelize
    ENV['CFLAGS'] += '-DJOHN_SYSTEMWIDE=1'
    ENV['CFLAGS'] += "-DJOHN_SYSTEMWIDE_HOME=#{(share+'john')}"
    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    system "chmod -R og+r ."

    Dir.chdir 'src' do
      system "make clean macosx-x86-#{arch}"
    end

    bin.install 'run/john'

    etc.install 'run/john.conf'

    (share+'john').install [
      'run/calc_stat',
      'run/generic.conf',
      'run/genincstats.rb',
      'run/ldif2pw.pl',
      'run/netntlm.pl',
      'run/netscreen.py',
      'run/password.lst',
      'run/sap_prepare.pl',
      'run/sha-dump.pl',
      'run/sha-test.pl',
      'run/stats'
    ]
    (share+'john').install Dir['run/*.chr']
    File.symlink bin+'john', (share+'john')+'pdf2john'
    File.symlink bin+'john', (share+'john')+'rar2john'
    File.symlink bin+'john', (share+'john')+'ssh2john'
    File.symlink bin+'john', (share+'john')+'unafs'
    File.symlink bin+'john', (share+'john')+'undrop'
    File.symlink bin+'john', (share+'john')+'unique'
    File.symlink bin+'john', (share+'john')+'unshadow'
    File.symlink bin+'john', (share+'john')+'zip2john'

    doc.install 'README-jumbo'
    doc.install Dir['doc/*']
  end
end
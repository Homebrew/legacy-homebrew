require 'formula'

class Salt < Formula
  homepage 'http://supernovae.in2p3.fr/salt/doku.php?id=start'
  url 'http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=snfit-2.4.0.tar.gz'
  sha1 '7f6e36e78199d8dec0458b464643e1e90fc51282'
  version '2.4'

  depends_on :fortran

  conflicts_with 'fastbit', :because => 'both install `include/filter.h`'

  resource 'data' do
    url 'http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=salt2-4_data.tgz'
    sha1 '92c34fe3363fe6a88c8cda75c543503a9b3196f7'
  end

  resource '03d4ag' do
    url 'http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=jla-03d4ag.tar.gz'
    sha1 'b227f5e50ea227375720f3c00dd849f964cfa2ba'
  end

  def install
    ENV.deparallelize
    # the libgfortran.a path needs to be set explicitly
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append 'LDFLAGS', "-L#{File.dirname(libgfortran)} -lgfortran"
    system "./configure", "--prefix=#{prefix}", "--disable-static"
    system "make install"
    # install all the model data
    (prefix/'data').install resource('data')
    # for testing
    (prefix/'03d4ag').install resource('03d4ag')
  end

  test do
    ENV['SALTPATH'] = "#{prefix}/data"
    cp_r Dir["#{prefix}/03d4ag/*"], '.'
    system bin/"snfit", testpath/"lc-03D4ag.list"
    assert File.exist?("result_salt2.dat")
  end

  def caveats
    <<-EOS.undent
    You should add the following to your .bashrc or equivalent:
      export SALTPATH=#{prefix}/data
    EOS
  end

end

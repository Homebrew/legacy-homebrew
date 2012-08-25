require 'formula'

class SaltSALT2 < Formula
  url 'http://supernovae.in2p3.fr/~guy/salt-dev/download/salt2_model_data-2-0.tar.gz'
  md5 'ed8c0ab8cf75dbb98643ddc7a76ba1a9'
end
class Salt04D3gx < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-04D3gx.tar.gz"
  md5 "17a03aa77636d8a5fb2eb9bc6fc48e75"
  version '2.2.2b'
end
class Salt4SHOOTER2 < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-4Shooter2.tar.gz"
  md5 "478ae9ca99f220a41eb923c230037ee4"
  version '2.2.2b'
end
class SaltSWOPE < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-CSP-Swope.tar.gz"
  md5 "d7e0ca6a982373dc775d19016bbdab40"
  version '2.2.2b'
end
class SaltACSWF < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-ACSWF.tar.gz"
  md5 "518521528b5af934b6d4281184b09ecd"
  version '2.2.2b'
end
class SaltNICMOS2 < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-NICMOS2.tar.gz"
  md5 "354e58e26d491ddcaec2dcf28c8b22e8"
  version '2.2.2b'
end
class SaltKEPLERCAM < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Keplercam.tar.gz"
  md5 "5c3f1c80e68a3faaa620d619c098cb49"
  version '2.2.2b'
end
class SaltSTANDARD < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Landolt-model.tar.gz"
  md5 "7d6e34688bc5cee02c89675f4213b4ca"
  version '2.2.2b'
end
class SaltMEGACAM < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Megacam-model.tar.gz"
  md5 "c2786e737f3a2d530e5ac3b941718b68"
  version '2.2.2b'
end
class SaltSDSS < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-model-Doi2010.tar.gz"
  md5 "118f6e2be45eebca0af89fe2f318548a"
  version '2.2.2b'
end
class SaltSDSS_AB_off < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-magsys.tar.gz"
  md5 "cf8c210fd19c3eef0b7f29b5d35c3270"
  version '2.2.2b'
  def linkto () return 'MagSys/SDSS-AB-off.dat' end
end
class SaltVEGAHST < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Vega-magsys.tar.gz"
  md5 "cf302ca85627ddeb2fbf590e0013dd3c"
  version '2.2.2b'
  def linkto () return 'MagSys/Vega0.dat' end
end
class SaltVEGA < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-magsys-1.tar.gz"
  md5 "69c161ff17748c683df685e0a2ea2910"
  version '2.2.2b'
  def linkto () return 'MagSys/BD17-snls3.dat' end
end

class Salt < Formula
  homepage 'http://supernovae.in2p3.fr/~guy/salt/'
  url 'http://supernovae.in2p3.fr/~guy/salt/download/snfit-2.2.2b.tar.gz'
  md5 'bf227accaf89a751c28d0bf1ed2b0851'

  option 'with-data', 'Install model data'

  def install_subbrew(subbrew, installdir)
    s = subbrew.new
    s.brew do
      d = File.basename Dir.pwd
      (installdir + d).install Dir['*']
      # the fitmodel file will link by default to the first dir
      # on the path right after #{prefix}/data/
      if s.respond_to? 'linkto'
        linkto = s.linkto
      else
        base = File.basename installdir
        linkto = base == 'data' ? d : File.join(base, d)
      end
      return "@#{subbrew.name.sub('Salt', '').gsub('_','-')} #{linkto}\n"
    end
  end

  def install
    ENV.deparallelize
    ENV.fortran
    # the libgfortran.a path needs to be set explicitly
    # for the --enable-gfortran option to work
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append 'LDFLAGS', "-L#{File.dirname libgfortran}"
    system "./configure", "--prefix=#{prefix}", "--enable-gfortran"
    system "make install"

    # install all the model data
    # http://supernovae.in2p3.fr/~guy/salt/download/snls3-intallation.sh
    if build.include? 'with-data'
      data = prefix/'data'
      data.mkpath
      File.open(data/'fitmodel.card', 'w') do |fitmodel|
        # salt2 model + magsys
        [SaltSALT2, SaltVEGA, SaltSDSS_AB_off, SaltVEGAHST].each do |cls|
          fitmodel.write(install_subbrew(cls, data))
        end
        # instruments
        inst = data + 'Instruments'
        [SaltSTANDARD, SaltMEGACAM, SaltKEPLERCAM, Salt4SHOOTER2, SaltSDSS,
         SaltSWOPE, SaltACSWF, SaltNICMOS2].each do |cls|
          fitmodel.write(install_subbrew(cls, inst))
        end
      end

      # for testing
      Salt04D3gx.new.brew { (prefix + '04D3gx').install Dir['*'] }
    end
  end

  def test
    mktemp do
      ENV['PATHMODEL'] = "#{prefix}/data"
      cp_r Dir[prefix + '04D3gx' + '*'], '.'
      # I don't know why I need to redo the cd on the shell, but it doesn't work otherwise
      system "cd #{Dir.pwd}; #{bin}/snfit lc2fit_g.dat lc2fit_r.dat lc2fit_i.dat lc2fit_z.dat"
      system "cat result_salt2.dat result_salt2_SNLS3.dat"
    end
  end

  def caveats
    if build.include? 'with-data'
      <<-EOS.undent
      You should add the following to your .bashrc or equivalent:
        export PATHMODEL=#{prefix}/data
      EOS
    end
  end

end

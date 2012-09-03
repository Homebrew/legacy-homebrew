require 'formula'

class SaltSALT2 < Formula
  url 'http://supernovae.in2p3.fr/~guy/salt-dev/download/salt2_model_data-2-0.tar.gz'
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
end
class Salt04D3gx < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-04D3gx.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class Salt4SHOOTER2 < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-4Shooter2.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltSWOPE < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-CSP-Swope.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltACSWF < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-ACSWF.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltNICMOS2 < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-HST-NICMOS2.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltKEPLERCAM < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Keplercam.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltSTANDARD < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Landolt-model.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltMEGACAM < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Megacam-model.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltSDSS < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-model-Doi2010.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
end
class SaltSDSS_AB_off < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-SDSS-magsys.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
  def linkto () return 'MagSys/SDSS-AB-off.dat' end
end
class SaltVEGAHST < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-Vega-magsys.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
  def linkto () return 'MagSys/Vega0.dat' end
end
class SaltVEGA < Formula
  url "http://supernovae.in2p3.fr/~guy/salt-dev/download/SNLS3-magsys-1.tar.gz"
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'
  version '2.2.2b'
  def linkto () return 'MagSys/BD17-snls3.dat' end
end

class Salt < Formula
  homepage 'http://supernovae.in2p3.fr/~guy/salt/'
  url 'http://supernovae.in2p3.fr/~guy/salt/download/snfit-2.2.2b.tar.gz'
  sha1 'e435ca19d22800f95f5363038297593ec4dae97f'

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

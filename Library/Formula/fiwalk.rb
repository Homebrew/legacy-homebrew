require 'formula'

class Fiwalk <Formula
  url 'http://afflib.org/downloads/fiwalk-0.6.0.tar.gz'
  homepage 'http://afflib.org/software/fiwalk'
  md5 '0d69f3f98ae01e4888b1276259590c5b'

  depends_on 'sleuthkit'
  depends_on 'afflib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name).mkpath
    cd 'plugins' do
      system "make install"
      system "make plugins.jar"
      libexec.install 'plugins.jar' => 'fiwalk-plugins.jar'
      bin.install Dir['*.py']
      inreplace 'ficonfig.txt' do |s|
        s.gsub! 'dgi	../plugins/jpeg_extract', "dgi	#{prefix}/jpeg_extract"
        s.gsub! '../plugins/plugins.jar', "#{libexec}/fiwalk-plugins.jar"
      end
      (share+name).install 'ficonfig.txt'
    end
    (share+name+'python').install Dir['python/*.py']
    %w[demo_plot_times.py demo_readtimes.py fiwalk.py iblkfind.py icarvingtruth.py idifference.py iextract.py igrep.py imap.py imicrosoft_redact.py iredact.py istats.py iverify.py iverify2.py sanitize_xml.py].each do |fn|
      chmod 0755, share+name+'python'+fn
      ln_s share+name+'python'+fn, bin
    end
  end

  def caveats; <<-EOS.undent
    fiwalk's config file is located at:
      #{share+name}/ficonfig.txt
    
    You may need to add the Python bindings to your PYTHONPATH from:
      #{share+name}/python
    EOS
  end
end

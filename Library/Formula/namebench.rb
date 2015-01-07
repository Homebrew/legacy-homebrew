require 'formula'

class Namebench < Formula
  homepage 'https://code.google.com/p/namebench/'
  url 'https://namebench.googlecode.com/files/namebench-1.3.1-source.tgz'
  sha1 '2e6ca5a4f20512cb967c5ac43b023cc38c271131'

  head do
    url 'http://namebench.googlecode.com/svn/trunk/'

    patch :p0 do
      url 'https://gist.githubusercontent.com/catap/888d3da014f0d8073401/raw/746f0aea15bc3791cf96234d6b79ad1bd2be4887/patch.diff'
      sha1 '43bb7f717c2cc188500615f833c131dae08962f1'
    end
  end

  option 'no-third-party', 'Do not install bundled third-party modules'

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV['NO_THIRD_PARTY']='1' if build.include?('no-third-party')

    system "python", "setup.py", "install", "--prefix=#{prefix}",
                                            "--install-data=#{lib}/python2.7/site-packages"

    bin.install "namebench.py" => "namebench"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/namebench", "--query_count", "1", "--only", "8.8.8.8"
  end
end
